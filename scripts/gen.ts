import { Project, ScriptKind, VariableDeclarationKind, SymbolFlags, SyntaxKind } from 'ts-morph'

const libDir = `${__dirname}/../lib`

const project = new Project()
const wgpuTypings = project.addExistingSourceFile(`${__dirname}/../node_modules/@webgpu/types/index.d.ts`)
const wgpuJsInterface = project.createSourceFile(`${libDir}/index.js`, undefined, {
  overwrite: true,
  scriptKind: ScriptKind.JS
})

const exportedClasses = wgpuTypings.getDescendantsOfKind(SyntaxKind.ClassDeclaration)
const gpuEntryClass = exportedClasses.find(classDecl => classDecl.getName() === 'GPU')
if (!gpuEntryClass) {
  throw "Expected to find class named 'GPU'."
}
gpuEntryClass.getMembers().forEach(member => console.log(member.print()))

process.exit(0)

const global = wgpuTypings.getVariableDeclarationOrThrow('global')
global.getChildrenOfKind(SyntaxKind.ClassDeclaration).forEach(console.log)

// dawnTypings.addExportDeclaration({
//   namedExports: []
// })

wgpuJsInterface.addVariableStatement({
  declarationKind: VariableDeclarationKind.Const,
  declarations: [{
    name: 'addon',
    initializer: "require('bindings')('teraflop')"
  }]
})

wgpuJsInterface.addStatements('console.log(addon.hello())')

wgpuJsInterface.formatText()

project.save().then(() => {
  console.log('Emitted WGPU FFI to JS bindings interface library')
}).catch(err => {
  console.error('Failed to emit WGPU FFI to JS bindings interface library\n')
  console.error(err)
  process.exit(1)
})
