###############################################################################################
# Generates a .artifact file that cotiains data from a build / deploy / update process
#
# id      argument                 example
#----------------------------------------------------------------------------------------------
# 1       output dir               'home/runner/work/repo/repo/package'
# 2       artifact-name            'github-actions'
# 3       artifact-type            ['action-dist', 'website-deploy', 'content-deploy']
# 4       artifact-sha             '5bc2dff'
# 5       artifact-package         '/home/runner/work/repo/repo/package'
# 6       artifact-author-user     'github-user'
# 7       artifact-author-email    'github-user@users.noreply.github.com'
# 8       artifact-publisher       'github-actions[bot]@users.noreply.github.com'
# 9      ?artifact-meta           '{ "cool-package": "true" }', default: '{}'

###############################################################################################

ARTIFACT_SIZE=9*3
ARIFACT_MALFORMED_CONTENT='{"artifact-content-malformed ":"true"}'

if (( $# < 8 || $# > 9 )) ; then
    echo "too many / too few arguments"
    exit 1
fi

if [ -z "$9" ] ; then
    ARTIFACT_META='{}'
elif [ `jq . <<< ${9} &>/dev/null; echo $?` -eq 0 ] ; then
    ARTIFACT_META=${9}
else
    echo "malformed artifact-meta, skipping."
    ARTIFACT_META=${ARIFACT_MALFORMED_CONTENT}
fi

ARTIFACT_PROPERTIES=(
    artifact-name          "${2}"                          value
    artifact-type          "${3}"                          value
    artifact-sha           "${4}"                          value
    artifact-package       "${5}"                          value
    artifact-author-user   "${6}"                          value
    artifact-author-email  "${7}"                          value
    artifact-publisher     "${8}"                          value
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
if [ "$?" -ne 0 ]; then
    echo "malformed artifact, skipping."
    GENERATED_ARTIFACT_DATA=$( jq . <<< "${ARIFACT_MALFORMED_CONTENT}" )
fi

cd $1
echo "${GENERATED_ARTIFACT_DATA[@]}" > .artifact
echo "generated artifact $4"
