import * as glob from '@actions/glob'

export async function crawlJavascriptSource(root: string) {
    var sourceMap = new Array<string>();

    const crawler = await glob.create(`${root}/**.js`)
    for await (const file of crawler.globGenerator()) {
        console.log(file)
        sourceMap.push(file)
    }
}