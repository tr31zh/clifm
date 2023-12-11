{"payload":{"allShortcutsEnabled":false,"fileTree":{"plugins":{"items":[{"name":"BFG.cfg","path":"plugins/BFG.cfg","contentType":"file"},{"name":"BFG.sh","path":"plugins/BFG.sh","contentType":"file"},{"name":"batch_copy.sh","path":"plugins/batch_copy.sh","contentType":"file"},{"name":"batch_create.sh","path":"plugins/batch_create.sh","contentType":"file"},{"name":"bm_import.sh","path":"plugins/bm_import.sh","contentType":"file"},{"name":"clip.sh","path":"plugins/clip.sh","contentType":"file"},{"name":"colors.sh","path":"plugins/colors.sh","contentType":"file"},{"name":"cprm.sh","path":"plugins/cprm.sh","contentType":"file"},{"name":"decrypt.sh","path":"plugins/decrypt.sh","contentType":"file"},{"name":"disk_analyzer.sh","path":"plugins/disk_analyzer.sh","contentType":"file"},{"name":"dragondrop.sh","path":"plugins/dragondrop.sh","contentType":"file"},{"name":"encrypt.sh","path":"plugins/encrypt.sh","contentType":"file"},{"name":"fdups.sh","path":"plugins/fdups.sh","contentType":"file"},{"name":"finder.sh","path":"plugins/finder.sh","contentType":"file"},{"name":"fzcd.sh","path":"plugins/fzcd.sh","contentType":"file"},{"name":"fzfdesel.sh","path":"plugins/fzfdesel.sh","contentType":"file"},{"name":"fzfhist.sh","path":"plugins/fzfhist.sh","contentType":"file"},{"name":"fzfnav.sh","path":"plugins/fzfnav.sh","contentType":"file"},{"name":"fzfsel.sh","path":"plugins/fzfsel.sh","contentType":"file"},{"name":"git_status.sh","path":"plugins/git_status.sh","contentType":"file"},{"name":"ihelp.sh","path":"plugins/ihelp.sh","contentType":"file"},{"name":"img_viewer.sh","path":"plugins/img_viewer.sh","contentType":"file"},{"name":"jumper.sh","path":"plugins/jumper.sh","contentType":"file"},{"name":"kbgen.c","path":"plugins/kbgen.c","contentType":"file"},{"name":"mime_list.sh","path":"plugins/mime_list.sh","contentType":"file"},{"name":"music_player.sh","path":"plugins/music_player.sh","contentType":"file"},{"name":"pager.sh","path":"plugins/pager.sh","contentType":"file"},{"name":"pdf_viewer.sh","path":"plugins/pdf_viewer.sh","contentType":"file"},{"name":"plugins-helper","path":"plugins/plugins-helper","contentType":"file"},{"name":"rgfind.sh","path":"plugins/rgfind.sh","contentType":"file"},{"name":"update.sh","path":"plugins/update.sh","contentType":"file"},{"name":"vid_viewer.sh","path":"plugins/vid_viewer.sh","contentType":"file"},{"name":"virtualize.sh","path":"plugins/virtualize.sh","contentType":"file"},{"name":"wallpaper_setter.sh","path":"plugins/wallpaper_setter.sh","contentType":"file"},{"name":"xclip.sh","path":"plugins/xclip.sh","contentType":"file"}],"totalCount":35},"":{"items":[{"name":".github","path":".github","contentType":"directory"},{"name":"functions","path":"functions","contentType":"directory"},{"name":"misc","path":"misc","contentType":"directory"},{"name":"plugins","path":"plugins","contentType":"directory"},{"name":"src","path":"src","contentType":"directory"},{"name":"translations","path":"translations","contentType":"directory"},{"name":".editorconfig","path":".editorconfig","contentType":"file"},{"name":".gitignore","path":".gitignore","contentType":"file"},{"name":"CHANGELOG","path":"CHANGELOG","contentType":"file"},{"name":"CMakeLists.txt","path":"CMakeLists.txt","contentType":"file"},{"name":"LICENSE","path":"LICENSE","contentType":"file"},{"name":"Makefile","path":"Makefile","contentType":"file"},{"name":"README.md","path":"README.md","contentType":"file"}],"totalCount":13}},"fileTreeProcessingTime":10.356195,"foldersToFetch":[],"reducedMotionEnabled":null,"repo":{"id":122135934,"defaultBranch":"master","name":"clifm","ownerLogin":"leo-arch","currentUserCanPush":false,"isFork":false,"isEmpty":false,"createdAt":"2018-02-19T23:53:56.000Z","ownerAvatar":"https://avatars.githubusercontent.com/u/21303106?v=4","public":true,"private":false,"isOrgOwned":false},"symbolsExpanded":false,"treeExpanded":true,"refInfo":{"name":"master","listCacheKey":"v0:1698351709.0","canEdit":false,"refType":"branch","currentOid":"7caa03e796bc10fd42dd1f7f0e9a982ba1bedd7b"},"path":"plugins/finder.sh","currentUser":null,"blob":{"rawLines":["#!/bin/sh","","# CliFM plugin to find/open/cd files using FZF/Rofi","# Written by L. Abramovich","# License GPL3","","# Dependencies: fzf or rofi, and sed","","SUCCESS=0","ERROR=1","","if [ -n \"$1\" ] && { [ \"$1\" = \"--help\" ] || [ \"$1\" = \"-h\" ]; }; then","\tname=\"${CLIFM_PLUGIN_NAME:-$(basename \"$0\")}\"","\tprintf \"Find/open/cd files using FZF/Rofi. Once found, press Enter to cd/open the desired file.\\n\"","\tprintf \"\\n\\x1b[1mUSAGE\\x1b[0m\\n  %s [DIR]\\n\" \"$name\"","\tprintf \"\\nNote: If DIR is not specified, the current directory is assumed\\n\"","\texit $SUCCESS","fi","","if type fzf > /dev/null 2>&1; then","\tfinder=\"fzf\"","elif type rofi > /dev/null 2>&1; then","\tfinder=\"rofi\"","else","\tprintf \"clifm: No finder found. Install either FZF or Rofi\\n\" >&2","\texit $ERROR","fi","","OS=\"$(uname -s)\"","","if [ -z \"$OS\" ]; then","\tprintf \"clifm: Unable to detect operating system\\n\" >&2","\texit $ERROR","fi","","# Source our plugins helper","if [ -z \"$CLIFM_PLUGINS_HELPER\" ] || ! [ -f \"$CLIFM_PLUGINS_HELPER\" ]; then","\tprintf \"clifm: Unable to find plugins-helper file\\n\" >&2","\texit 1","fi","# shellcheck source=/dev/null",". \"$CLIFM_PLUGINS_HELPER\"","","DIR=\".\"","if [ -n \"$1\" ]; then","\tif [ -d \"$1\" ]; then","\t\tDIR=\"$1\";","\telse","\t\tprintf \"clifm: %s: Not a directory\\n\" \"$1\" >&2","\t\texit 1","\tfi","fi","","case \"$OS\" in","\tLinux) ls_cmd=\"ls -A --group-directories-first --color=always $DIR\" ;;","\t*) ls_cmd=\"ls -A $DIR\" ;;","esac","","if [ \"$finder\" = \"fzf\" ]; then","\t# shellcheck disable=SC2012","\t# shellcheck disable=SC2154","\tFILE=\"$($ls_cmd | fzf --ansi --prompt \"$fzf_prompt\" \\","\t--reverse --height \"$fzf_height\" --info=inline \\","\t--header \"Find files in the current directory\" \\","\t--bind \"tab:accept\" --info=inline --color=\"$(get_fzf_colors)\")\"","else","\t# shellcheck disable=SC2012","\tFILE=\"$(ls -A | rofi -dmenu -p CliFM)\"","fi","","if [ -n \"$FILE\" ]; then","\tf=\"$(echo \"$FILE\" | sed 's/ /\\\\ /g')\"","\tprintf \"open %s/%s\\n\" \"$DIR\" \"$f\" > \"$CLIFM_BUS\"","fi","","exit $SUCCESS"],"stylingDirectives":[[{"start":0,"end":9,"cssClass":"pl-c"},{"start":0,"end":2,"cssClass":"pl-c"}],[],[{"start":0,"end":51,"cssClass":"pl-c"},{"start":0,"end":1,"cssClass":"pl-c"}],[{"start":0,"end":26,"cssClass":"pl-c"},{"start":0,"end":1,"cssClass":"pl-c"}],[{"start":0,"end":14,"cssClass":"pl-c"},{"start":0,"end":1,"cssClass":"pl-c"}],[],[{"start":0,"end":36,"cssClass":"pl-c"},{"start":0,"end":1,"cssClass":"pl-c"}],[],[],[],[],[{"start":0,"end":2,"cssClass":"pl-k"},{"start":5,"end":7,"cssClass":"pl-k"},{"start":8,"end":12,"cssClass":"pl-s"},{"start":8,"end":9,"cssClass":"pl-pds"},{"start":9,"end":11,"cssClass":"pl-smi"},{"start":11,"end":12,"cssClass":"pl-pds"},{"start":15,"end":17,"cssClass":"pl-k"},{"start":22,"end":26,"cssClass":"pl-s"},{"start":22,"end":23,"cssClass":"pl-pds"},{"start":23,"end":25,"cssClass":"pl-smi"},{"start":25,"end":26,"cssClass":"pl-pds"},{"start":27,"end":28,"cssClass":"pl-k"},{"start":29,"end":37,"cssClass":"pl-s"},{"start":29,"end":30,"cssClass":"pl-pds"},{"start":36,"end":37,"cssClass":"pl-pds"},{"start":40,"end":42,"cssClass":"pl-k"},{"start":45,"end":49,"cssClass":"pl-s"},{"start":45,"end":46,"cssClass":"pl-pds"},{"start":46,"end":48,"cssClass":"pl-smi"},{"start":48,"end":49,"cssClass":"pl-pds"},{"start":50,"end":51,"cssClass":"pl-k"},{"start":52,"end":56,"cssClass":"pl-s"},{"start":52,"end":53,"cssClass":"pl-pds"},{"start":55,"end":56,"cssClass":"pl-pds"},{"start":58,"end":59,"cssClass":"pl-k"},{"start":61,"end":62,"cssClass":"pl-k"},{"start":63,"end":67,"cssClass":"pl-k"}],[{"start":6,"end":46,"cssClass":"pl-s"},{"start":6,"end":7,"cssClass":"pl-pds"},{"start":7,"end":45,"cssClass":"pl-smi"},{"start":26,"end":28,"cssClass":"pl-k"},{"start":39,"end":43,"cssClass":"pl-s"},{"start":39,"end":40,"cssClass":"pl-pds"},{"start":40,"end":42,"cssClass":"pl-smi"},{"start":42,"end":43,"cssClass":"pl-pds"},{"start":45,"end":46,"cssClass":"pl-pds"}],[{"start":1,"end":7,"cssClass":"pl-c1"},{"start":8,"end":99,"cssClass":"pl-s"},{"start":8,"end":9,"cssClass":"pl-pds"},{"start":98,"end":99,"cssClass":"pl-pds"}],[{"start":1,"end":7,"cssClass":"pl-c1"},{"start":8,"end":45,"cssClass":"pl-s"},{"start":8,"end":9,"cssClass":"pl-pds"},{"start":44,"end":45,"cssClass":"pl-pds"},{"start":46,"end":53,"cssClass":"pl-s"},{"start":46,"end":47,"cssClass":"pl-pds"},{"start":47,"end":52,"cssClass":"pl-smi"},{"start":52,"end":53,"cssClass":"pl-pds"}],[{"start":1,"end":7,"cssClass":"pl-c1"},{"start":8,"end":77,"cssClass":"pl-s"},{"start":8,"end":9,"cssClass":"pl-pds"},{"start":76,"end":77,"cssClass":"pl-pds"}],[{"start":1,"end":5,"cssClass":"pl-c1"},{"start":6,"end":14,"cssClass":"pl-smi"}],[{"start":0,"end":2,"cssClass":"pl-k"}],[],[{"start":0,"end":2,"cssClass":"pl-k"},{"start":3,"end":7,"cssClass":"pl-c1"},{"start":12,"end":13,"cssClass":"pl-k"},{"start":24,"end":28,"cssClass":"pl-k"},{"start":28,"end":29,"cssClass":"pl-k"},{"start":30,"end":34,"cssClass":"pl-k"}],[{"start":8,"end":13,"cssClass":"pl-s"},{"start":8,"end":9,"cssClass":"pl-pds"},{"start":12,"end":13,"cssClass":"pl-pds"}],[{"start":0,"end":4,"cssClass":"pl-k"},{"start":5,"end":9,"cssClass":"pl-c1"},{"start":15,"end":16,"cssClass":"pl-k"},{"start":27,"end":31,"cssClass":"pl-k"},{"start":31,"end":32,"cssClass":"pl-k"},{"start":33,"end":37,"cssClass":"pl-k"}],[{"start":8,"end":14,"cssClass":"pl-s"},{"start":8,"end":9,"cssClass":"pl-pds"},{"start":13,"end":14,"cssClass":"pl-pds"}],[{"start":0,"end":4,"cssClass":"pl-k"}],[{"start":1,"end":7,"cssClass":"pl-c1"},{"start":8,"end":62,"cssClass":"pl-s"},{"start":8,"end":9,"cssClass":"pl-pds"},{"start":61,"end":62,"cssClass":"pl-pds"},{"start":63,"end":66,"cssClass":"pl-k"}],[{"start":1,"end":5,"cssClass":"pl-c1"},{"start":6,"end":12,"cssClass":"pl-smi"}],[{"start":0,"end":2,"cssClass":"pl-k"}],[],[{"start":3,"end":16,"cssClass":"pl-s"},{"start":3,"end":4,"cssClass":"pl-pds"},{"start":4,"end":15,"cssClass":"pl-s"},{"start":4,"end":6,"cssClass":"pl-pds"},{"start":14,"end":15,"cssClass":"pl-pds"},{"start":15,"end":16,"cssClass":"pl-pds"}],[],[{"start":0,"end":2,"cssClass":"pl-k"},{"start":5,"end":7,"cssClass":"pl-k"},{"start":8,"end":13,"cssClass":"pl-s"},{"start":8,"end":9,"cssClass":"pl-pds"},{"start":9,"end":12,"cssClass":"pl-smi"},{"start":12,"end":13,"cssClass":"pl-pds"},{"start":15,"end":16,"cssClass":"pl-k"},{"start":17,"end":21,"cssClass":"pl-k"}],[{"start":1,"end":7,"cssClass":"pl-c1"},{"start":8,"end":52,"cssClass":"pl-s"},{"start":8,"end":9,"cssClass":"pl-pds"},{"start":51,"end":52,"cssClass":"pl-pds"},{"start":53,"end":56,"cssClass":"pl-k"}],[{"start":1,"end":5,"cssClass":"pl-c1"},{"start":6,"end":12,"cssClass":"pl-smi"}],[{"start":0,"end":2,"cssClass":"pl-k"}],[],[{"start":0,"end":27,"cssClass":"pl-c"},{"start":0,"end":1,"cssClass":"pl-c"}],[{"start":0,"end":2,"cssClass":"pl-k"},{"start":5,"end":7,"cssClass":"pl-k"},{"start":8,"end":31,"cssClass":"pl-s"},{"start":8,"end":9,"cssClass":"pl-pds"},{"start":9,"end":30,"cssClass":"pl-smi"},{"start":30,"end":31,"cssClass":"pl-pds"},{"start":34,"end":36,"cssClass":"pl-k"},{"start":37,"end":38,"cssClass":"pl-k"},{"start":41,"end":43,"cssClass":"pl-k"},{"start":44,"end":67,"cssClass":"pl-s"},{"start":44,"end":45,"cssClass":"pl-pds"},{"start":45,"end":66,"cssClass":"pl-smi"},{"start":66,"end":67,"cssClass":"pl-pds"},{"start":69,"end":70,"cssClass":"pl-k"},{"start":71,"end":75,"cssClass":"pl-k"}],[{"start":1,"end":7,"cssClass":"pl-c1"},{"start":8,"end":53,"cssClass":"pl-s"},{"start":8,"end":9,"cssClass":"pl-pds"},{"start":52,"end":53,"cssClass":"pl-pds"},{"start":54,"end":57,"cssClass":"pl-k"}],[{"start":1,"end":5,"cssClass":"pl-c1"}],[{"start":0,"end":2,"cssClass":"pl-k"}],[{"start":0,"end":29,"cssClass":"pl-c"},{"start":0,"end":1,"cssClass":"pl-c"}],[{"start":0,"end":1,"cssClass":"pl-c1"},{"start":2,"end":25,"cssClass":"pl-s"},{"start":2,"end":3,"cssClass":"pl-pds"},{"start":3,"end":24,"cssClass":"pl-smi"},{"start":24,"end":25,"cssClass":"pl-pds"}],[],[{"start":4,"end":7,"cssClass":"pl-s"},{"start":4,"end":5,"cssClass":"pl-pds"},{"start":6,"end":7,"cssClass":"pl-pds"}],[{"start":0,"end":2,"cssClass":"pl-k"},{"start":5,"end":7,"cssClass":"pl-k"},{"start":8,"end":12,"cssClass":"pl-s"},{"start":8,"end":9,"cssClass":"pl-pds"},{"start":9,"end":11,"cssClass":"pl-smi"},{"start":11,"end":12,"cssClass":"pl-pds"},{"start":14,"end":15,"cssClass":"pl-k"},{"start":16,"end":20,"cssClass":"pl-k"}],[{"start":1,"end":3,"cssClass":"pl-k"},{"start":6,"end":8,"cssClass":"pl-k"},{"start":9,"end":13,"cssClass":"pl-s"},{"start":9,"end":10,"cssClass":"pl-pds"},{"start":10,"end":12,"cssClass":"pl-smi"},{"start":12,"end":13,"cssClass":"pl-pds"},{"start":15,"end":16,"cssClass":"pl-k"},{"start":17,"end":21,"cssClass":"pl-k"}],[{"start":6,"end":10,"cssClass":"pl-s"},{"start":6,"end":7,"cssClass":"pl-pds"},{"start":7,"end":9,"cssClass":"pl-smi"},{"start":9,"end":10,"cssClass":"pl-pds"},{"start":10,"end":11,"cssClass":"pl-k"}],[{"start":1,"end":5,"cssClass":"pl-k"}],[{"start":2,"end":8,"cssClass":"pl-c1"},{"start":9,"end":39,"cssClass":"pl-s"},{"start":9,"end":10,"cssClass":"pl-pds"},{"start":38,"end":39,"cssClass":"pl-pds"},{"start":40,"end":44,"cssClass":"pl-s"},{"start":40,"end":41,"cssClass":"pl-pds"},{"start":41,"end":43,"cssClass":"pl-smi"},{"start":43,"end":44,"cssClass":"pl-pds"},{"start":45,"end":48,"cssClass":"pl-k"}],[{"start":2,"end":6,"cssClass":"pl-c1"}],[{"start":1,"end":3,"cssClass":"pl-k"}],[{"start":0,"end":2,"cssClass":"pl-k"}],[],[{"start":0,"end":4,"cssClass":"pl-k"},{"start":5,"end":10,"cssClass":"pl-s"},{"start":5,"end":6,"cssClass":"pl-pds"},{"start":6,"end":9,"cssClass":"pl-smi"},{"start":9,"end":10,"cssClass":"pl-pds"},{"start":11,"end":13,"cssClass":"pl-k"}],[{"start":15,"end":68,"cssClass":"pl-s"},{"start":15,"end":16,"cssClass":"pl-pds"},{"start":63,"end":67,"cssClass":"pl-smi"},{"start":67,"end":68,"cssClass":"pl-pds"}],[{"start":1,"end":2,"cssClass":"pl-k"},{"start":11,"end":23,"cssClass":"pl-s"},{"start":11,"end":12,"cssClass":"pl-pds"},{"start":18,"end":22,"cssClass":"pl-smi"},{"start":22,"end":23,"cssClass":"pl-pds"}],[{"start":0,"end":4,"cssClass":"pl-k"}],[],[{"start":0,"end":2,"cssClass":"pl-k"},{"start":5,"end":14,"cssClass":"pl-s"},{"start":5,"end":6,"cssClass":"pl-pds"},{"start":6,"end":13,"cssClass":"pl-smi"},{"start":13,"end":14,"cssClass":"pl-pds"},{"start":15,"end":16,"cssClass":"pl-k"},{"start":17,"end":22,"cssClass":"pl-s"},{"start":17,"end":18,"cssClass":"pl-pds"},{"start":21,"end":22,"cssClass":"pl-pds"},{"start":24,"end":25,"cssClass":"pl-k"},{"start":26,"end":30,"cssClass":"pl-k"}],[{"start":1,"end":28,"cssClass":"pl-c"},{"start":1,"end":2,"cssClass":"pl-c"}],[{"start":1,"end":28,"cssClass":"pl-c"},{"start":1,"end":2,"cssClass":"pl-c"}],[{"start":6,"end":54,"cssClass":"pl-s"},{"start":6,"end":7,"cssClass":"pl-pds"},{"start":7,"end":54,"cssClass":"pl-s"},{"start":7,"end":9,"cssClass":"pl-pds"},{"start":9,"end":16,"cssClass":"pl-smi"},{"start":17,"end":18,"cssClass":"pl-k"},{"start":39,"end":52,"cssClass":"pl-s"},{"start":39,"end":40,"cssClass":"pl-pds"},{"start":40,"end":51,"cssClass":"pl-smi"},{"start":51,"end":52,"cssClass":"pl-pds"}],[{"start":0,"end":49,"cssClass":"pl-s"},{"start":0,"end":49,"cssClass":"pl-s"},{"start":20,"end":33,"cssClass":"pl-s"},{"start":20,"end":21,"cssClass":"pl-pds"},{"start":21,"end":32,"cssClass":"pl-smi"},{"start":32,"end":33,"cssClass":"pl-pds"}],[{"start":0,"end":49,"cssClass":"pl-s"},{"start":0,"end":49,"cssClass":"pl-s"},{"start":10,"end":47,"cssClass":"pl-s"},{"start":10,"end":11,"cssClass":"pl-pds"},{"start":46,"end":47,"cssClass":"pl-pds"}],[{"start":0,"end":64,"cssClass":"pl-s"},{"start":0,"end":63,"cssClass":"pl-s"},{"start":8,"end":20,"cssClass":"pl-s"},{"start":8,"end":9,"cssClass":"pl-pds"},{"start":19,"end":20,"cssClass":"pl-pds"},{"start":43,"end":62,"cssClass":"pl-s"},{"start":43,"end":44,"cssClass":"pl-pds"},{"start":44,"end":61,"cssClass":"pl-s"},{"start":44,"end":46,"cssClass":"pl-pds"},{"start":60,"end":61,"cssClass":"pl-pds"},{"start":61,"end":62,"cssClass":"pl-pds"},{"start":62,"end":63,"cssClass":"pl-pds"},{"start":63,"end":64,"cssClass":"pl-pds"}],[{"start":0,"end":4,"cssClass":"pl-k"}],[{"start":1,"end":28,"cssClass":"pl-c"},{"start":1,"end":2,"cssClass":"pl-c"}],[{"start":6,"end":39,"cssClass":"pl-s"},{"start":6,"end":7,"cssClass":"pl-pds"},{"start":7,"end":38,"cssClass":"pl-s"},{"start":7,"end":9,"cssClass":"pl-pds"},{"start":15,"end":16,"cssClass":"pl-k"},{"start":37,"end":38,"cssClass":"pl-pds"},{"start":38,"end":39,"cssClass":"pl-pds"}],[{"start":0,"end":2,"cssClass":"pl-k"}],[],[{"start":0,"end":2,"cssClass":"pl-k"},{"start":5,"end":7,"cssClass":"pl-k"},{"start":8,"end":15,"cssClass":"pl-s"},{"start":8,"end":9,"cssClass":"pl-pds"},{"start":9,"end":14,"cssClass":"pl-smi"},{"start":14,"end":15,"cssClass":"pl-pds"},{"start":17,"end":18,"cssClass":"pl-k"},{"start":19,"end":23,"cssClass":"pl-k"}],[{"start":3,"end":38,"cssClass":"pl-s"},{"start":3,"end":4,"cssClass":"pl-pds"},{"start":4,"end":37,"cssClass":"pl-s"},{"start":4,"end":6,"cssClass":"pl-pds"},{"start":11,"end":18,"cssClass":"pl-s"},{"start":11,"end":12,"cssClass":"pl-pds"},{"start":12,"end":17,"cssClass":"pl-smi"},{"start":17,"end":18,"cssClass":"pl-pds"},{"start":19,"end":20,"cssClass":"pl-k"},{"start":25,"end":36,"cssClass":"pl-s"},{"start":25,"end":26,"cssClass":"pl-pds"},{"start":35,"end":36,"cssClass":"pl-pds"},{"start":36,"end":37,"cssClass":"pl-pds"},{"start":37,"end":38,"cssClass":"pl-pds"}],[{"start":1,"end":7,"cssClass":"pl-c1"},{"start":8,"end":22,"cssClass":"pl-s"},{"start":8,"end":9,"cssClass":"pl-pds"},{"start":21,"end":22,"cssClass":"pl-pds"},{"start":23,"end":29,"cssClass":"pl-s"},{"start":23,"end":24,"cssClass":"pl-pds"},{"start":24,"end":28,"cssClass":"pl-smi"},{"start":28,"end":29,"cssClass":"pl-pds"},{"start":30,"end":34,"cssClass":"pl-s"},{"start":30,"end":31,"cssClass":"pl-pds"},{"start":31,"end":33,"cssClass":"pl-smi"},{"start":33,"end":34,"cssClass":"pl-pds"},{"start":35,"end":36,"cssClass":"pl-k"},{"start":37,"end":49,"cssClass":"pl-s"},{"start":37,"end":38,"cssClass":"pl-pds"},{"start":38,"end":48,"cssClass":"pl-smi"},{"start":48,"end":49,"cssClass":"pl-pds"}],[{"start":0,"end":2,"cssClass":"pl-k"}],[],[{"start":0,"end":4,"cssClass":"pl-c1"},{"start":5,"end":13,"cssClass":"pl-smi"}]],"csv":null,"csvError":null,"dependabotInfo":{"showConfigurationBanner":false,"configFilePath":null,"networkDependabotPath":"/leo-arch/clifm/network/updates","dismissConfigurationNoticePath":"/settings/dismiss-notice/dependabot_configuration_notice","configurationNoticeDismissed":null,"repoAlertsPath":"/leo-arch/clifm/security/dependabot","repoSecurityAndAnalysisPath":"/leo-arch/clifm/settings/security_analysis","repoOwnerIsOrg":false,"currentUserCanAdminRepo":false},"displayName":"finder.sh","displayUrl":"https://github.com/leo-arch/clifm/blob/master/plugins/finder.sh?raw=true","headerInfo":{"blobSize":"1.79 KB","deleteInfo":{"deleteTooltip":"You must be signed in to make or propose changes"},"editInfo":{"editTooltip":"You must be signed in to make or propose changes"},"ghDesktopPath":"https://desktop.github.com","gitLfsPath":null,"onBranch":true,"shortPath":"0a97a58","siteNavLoginPath":"/login?return_to=https%3A%2F%2Fgithub.com%2Fleo-arch%2Fclifm%2Fblob%2Fmaster%2Fplugins%2Ffinder.sh","isCSV":false,"isRichtext":false,"toc":null,"lineInfo":{"truncatedLoc":"76","truncatedSloc":"63"},"mode":"executable file"},"image":false,"isCodeownersFile":null,"isPlain":false,"isValidLegacyIssueTemplate":false,"issueTemplateHelpUrl":"https://docs.github.com/articles/about-issue-and-pull-request-templates","issueTemplate":null,"discussionTemplate":null,"language":"Shell","languageID":346,"large":false,"loggedIn":false,"newDiscussionPath":"/leo-arch/clifm/discussions/new","newIssuePath":"/leo-arch/clifm/issues/new","planSupportInfo":{"repoIsFork":null,"repoOwnedByCurrentUser":null,"requestFullPath":"/leo-arch/clifm/blob/master/plugins/finder.sh","showFreeOrgGatedFeatureMessage":null,"showPlanSupportBanner":null,"upgradeDataAttributes":null,"upgradePath":null},"publishBannersInfo":{"dismissActionNoticePath":"/settings/dismiss-notice/publish_action_from_dockerfile","dismissStackNoticePath":"/settings/dismiss-notice/publish_stack_from_file","releasePath":"/leo-arch/clifm/releases/new?marketplace=true","showPublishActionBanner":false,"showPublishStackBanner":false},"rawBlobUrl":"https://github.com/leo-arch/clifm/raw/master/plugins/finder.sh","renderImageOrRaw":false,"richText":null,"renderedFileInfo":null,"shortPath":null,"tabSize":4,"topBannersInfo":{"overridingGlobalFundingFile":false,"globalPreferredFundingPath":null,"repoOwner":"leo-arch","repoName":"clifm","showInvalidCitationWarning":false,"citationHelpUrl":"https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/creating-a-repository-on-github/about-citation-files","showDependabotConfigurationBanner":false,"actionsOnboardingTip":null},"truncated":false,"viewable":true,"workflowRedirectUrl":null,"symbols":{"timedOut":false,"notAnalyzed":false,"symbols":[]}},"copilotInfo":null,"copilotAccessAllowed":false,"csrf_tokens":{"/leo-arch/clifm/branches":{"post":"85CubkV0aQsBbc3oZQBcT-KJYB9jWhoKYwHgQQ4RoN3VHPQZh6T71lAEpGzXV9FSrX6vT0kUJ5EHXhhavg8oNA"},"/repos/preferences":{"post":"MxxVan_CnZ4-MIwovDoxiLchJWK4HLrPFITieIuF9zN1kjcHQxVH6ZmXq4xnLG2Aswt8ZFti-iAiTjnitqbwZg"}}},"title":"clifm/plugins/finder.sh at master · leo-arch/clifm"}