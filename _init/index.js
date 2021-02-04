async function run() {
    try {
        const pwshFolder = __dirname.replace(/[/\\]_init$/, '');
        const pwshScript = `${pwshFolder}/action.ps1`
        await exec.exec('pwsh', [ '-f', pwshScript ]);
    } catch (error) {
        core.setFailed(error.message);
    }
}
run();