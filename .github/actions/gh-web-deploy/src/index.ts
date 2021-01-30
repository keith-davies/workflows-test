import * as core from '@actions/core';
import * as github from '@actions/github';

import * as deploy from './deploy';

function checkInputBool(str: string): boolean {
    return str.toLowerCase() === 'true'
}

try {
    let optMinifySrc         = checkInputBool(core.getInput('minify-src'));
    let optMinifyResourceRef = checkInputBool(core.getInput('minify-res-ref'));
    let optStripJSMacros     = checkInputBool(core.getInput('strip-jsmacros'));
    let optGenerateArtifacts = checkInputBool(core.getInput('generate-artifacts'));

    var executor = new deploy.DeployExecutor(
        new deploy.DeployParameters(
            optMinifySrc, optMinifyResourceRef, 
            optStripJSMacros, optGenerateArtifacts
        )
    )

    executor.dispatch();

    executor.cleanup();
} catch (error) {
    core.setFailed(error.message);
}