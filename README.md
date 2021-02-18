This allows you to re-create the MySpace Top 8 section on any .md file in your GitHub Repository.

This defaults to the README.md at the root of your repository (which is the file that renders your profile) but you can specify any file in your repo, as long as it contains the following comments:

```
<!-- MYTOP8-LIST:START -->
<!-- MYTOP8-LIST:END -->
```

In your repository workflow file, you provide a comma-delimited list of 8 (or less) users that you want to make up your Top8 section. Here's an example workflow that will run every hour.

```yaml
name: My Top 8
on:
  schedule:
  #runs every hour
  - cron: '0 * * * *'
  workflow_dispatch:

jobs:
  update-mytop8-section:
    name: Update this repo's README my top 8 users.
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: matthewjdegarmo/MyTop8@latest
        with:
          users_list: --MyspaceTom--, matthewjdegarmo, brrees01, intenseone, EdwardHanlon, endoleg, packersking, TylerLeonhardt
```
The above workflow will render the following table in your root README.md file in your repository.

<!-- MYTOP8-LIST:START -->
<table style="border-collapse: collapse;" border="1"><tbody>
<td style=''><p><a href='https://twitter.com/myspacetom'><img style='display: block; margin-left: auto; margin-right: auto;' src='https://pbs.twimg.com/profile_images/1237550450/mstom_400x400.jpg' alt='' width='145' height='145' /></a></p><p style='text-align: center;'>1. <a href='https://twitter.com/myspacetom'>Tom</a></p></td>
<td style=''><p><a href='https://github.com/matthewjdegarmo'><img style='display: block; margin-left: auto; margin-right: auto;' src='https://github.com/matthewjdegarmo.png' alt='' width='145' height='145' /></a></p><p style='text-align: center;'>2. <a href='https://github.com/matthewjdegarmo'>matthewjdegarmo</a></p></td>
<td style=''><p><a href='https://github.com/brrees01'><img style='display: block; margin-left: auto; margin-right: auto;' src='https://github.com/brrees01.png' alt='' width='145' height='145' /></a></p><p style='text-align: center;'>3. <a href='https://github.com/brrees01'>brrees01</a></p></td>
<td style=''><p><a href='https://github.com/intenseone'><img style='display: block; margin-left: auto; margin-right: auto;' src='https://github.com/intenseone.png' alt='' width='145' height='145' /></a></p><p style='text-align: center;'>4. <a href='https://github.com/intenseone'>intenseone</a></p></td>
</tr><tr><td style=''><p><a href='https://github.com/EdwardHanlon'><img style='display: block; margin-left: auto; margin-right: auto;' src='https://github.com/EdwardHanlon.png' alt='' width='145' height='145' /></a></p><p style='text-align: center;'>5. <a href='https://github.com/EdwardHanlon'>EdwardHanlon</a></p></td>
<td style=''><p><a href='https://github.com/endoleg'><img style='display: block; margin-left: auto; margin-right: auto;' src='https://github.com/endoleg.png' alt='' width='145' height='145' /></a></p><p style='text-align: center;'>6. <a href='https://github.com/endoleg'>endoleg</a></p></td>
<td style=''><p><a href='https://github.com/packersking'><img style='display: block; margin-left: auto; margin-right: auto;' src='https://github.com/packersking.png' alt='' width='145' height='145' /></a></p><p style='text-align: center;'>7. <a href='https://github.com/packersking'>packersking</a></p></td>
<td style=''><p><a href='https://github.com/TylerLeonhardt'><img style='display: block; margin-left: auto; margin-right: auto;' src='https://github.com/TylerLeonhardt.png' alt='' width='145' height='145' /></a></p><p style='text-align: center;'>8. <a href='https://github.com/TylerLeonhardt'>TylerLeonhardt</a></p></td>
</tr></tbody></table>
<!-- MYTOP8-LIST:END -->
