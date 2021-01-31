###############################################################################################
# Generates a .artifact file that cotiains data from a build / deploy / update process
#
# id      argument                 example
#----------------------------------------------------------------------------------------------
# 1       artifact-name            'github-actions'
# 2       artifact-type            ['action-dist', 'website-deploy', 'content-deploy']
# 3       artifact-sha             '5bc2dff'
# 4       artifact-package         '/home/runner/work/repo/repo/package'
# 5       artifact-author-user     'github-user'
# 6       artifact-author-email    'github-user@users.noreply.github.com'
# 7       artifact-publisher       'github-actions[bot]@users.noreply.github.com'
# 8       ?artifact-meta           '{ "cool-package": "true" }', default: '{}'

###############################################################################################

ARTIFACT_SIZE=8*3
ARIFACT_MALFORMED_CONTENT='{"artifact-content-malformed ":"true"}'

if (( $# < 7 || $# > 8 )) ; then
    echo "too many / too few arguments"
    exit 1
fi

if [[ ! -d $4 ]] ; then
    echo "could not find artifact-package '$4'"
    exit 1
fi

if [ -z "$8" ] ; then
    ARTIFACT_META='{}'
elif [ `jq . <<< ${8} &>/dev/null; echo $?` -eq 0 ] ; then
    ARTIFACT_META=${8}
else
    echo "malformed artifact-meta, skipping."
    ARTIFACT_META=${ARIFACT_MALFORMED_CONTENT}
fi

ARTIFACT_PROPERTIES=(
    artifact-name          "${1}"                          value
    artifact-type          "${2}"                          value
    artifact-sha           "${3}"                          value
    artifact-package       "${4}"                          value
    artifact-author-user   "${5}"                          value
    artifact-author-email  "${6}"                          value
    artifact-publisher     "${7}"                          value
    artifact-creation-date "$(date +'%Y-%m-%dT%H:%M:%SZ')" value
    artifact-meta          "$ARTIFACT_META"                child
)

for ((i=0; i<$ARTIFACT_SIZE; i+=3)); do
    if [[ ${ARTIFACT_PROPERTIES[i+2]} == "value" ]]; then
        COMPILED_ARTIFACT_DATA+=\"${ARTIFACT_PROPERTIES[i]}\":\"${ARTIFACT_PROPERTIES[i+1]}\",
    elif [[ ${ARTIFACT_PROPERTIES[i+2]} == "child" ]]; then
        COMPILED_ARTIFACT_DATA+=\"${ARTIFACT_PROPERTIES[i]}\":${ARTIFACT_PROPERTIES[i+1]},
    fi
done

GENERATED_ARTIFACT_DATA=$( jq . <<< "{${COMPILED_ARTIFACT_DATA::-1}}" )
echo "${GENERATED_ARTIFACT_DATA[@]}"
if [ "$#" -ne 0 ]; then
    echo "malformed artifact, skipping."
    GENERATED_ARTIFACT_DATA=$( jq . <<< "${ARIFACT_MALFORMED_CONTENT}" )
fi

cd $4
echo "${GENERATED_ARTIFACT_DATA[@]}" > .artifact
echo "generated artifact $3"
