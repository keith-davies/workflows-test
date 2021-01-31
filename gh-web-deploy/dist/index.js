"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    Object.defineProperty(o, k2, { enumerable: true, get: function() { return m[k]; } });
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
const core = __importStar(require("@actions/core"));
const deploy = __importStar(require("./deploy"));
function checkInputBool(str) {
    return str.toLowerCase() === 'true';
}
try {
    let optMinifySrc = checkInputBool(core.getInput('minify-src'));
    let optMinifyResourceRef = checkInputBool(core.getInput('minify-res-ref'));
    let optStripJSMacros = checkInputBool(core.getInput('strip-jsmacros'));
    let optGenerateArtifacts = checkInputBool(core.getInput('generate-artifacts'));
    var executor = new deploy.DeployExecutor(new deploy.DeployParameters(optMinifySrc, optMinifyResourceRef, optStripJSMacros, optGenerateArtifacts));
    executor.dispatch();
    executor.cleanup();
}
catch (error) {
    core.setFailed(error.message);
}
