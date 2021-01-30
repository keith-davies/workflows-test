import * as crawl from './crawl'

export class DeployParameters {
    public readonly minifySources: boolean
    public readonly minifyResourceReferences: boolean
    public readonly stripJSMacroSymbols: boolean
    public readonly generateArtifacts: boolean

    constructor(minifySrc: boolean, 
                minifyResourceRef: boolean, 
                stripJSMacro: boolean, 
                generateArtifacts: boolean) {
        this.minifySources = minifySrc
        this.minifyResourceReferences = minifyResourceRef
        this.stripJSMacroSymbols = stripJSMacro
        this.generateArtifacts = generateArtifacts
    }
}

export class DeployExecutor {
    private mParameters: DeployParameters

    private mReferenceGraph: Map<string, Array<String>>

    constructor(parameters: DeployParameters) {
        this.mParameters = parameters
        this.mReferenceGraph = new Map();
    }

    async dispatch() {
        await crawl.crawlJavascriptSource('src/')
    }

    async cleanup() {

    }
}