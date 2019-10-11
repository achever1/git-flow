# Git flow

## Introduction
A vanilla git flow blog post is available [here](https://nvie.com/posts/a-successful-git-branching-model/).

A blog post explaining how to use [git-flow (AVH Edition)](https://github.com/petervanderdoes/gitflow-avh) is available [here](https://jeffkreeftmeijer.com/git-flow/).

## Installation git-flow (AVH Edition)
See the Wiki for up-to-date [Installation Instructions](https://github.com/petervanderdoes/gitflow-avh/wiki/Installation).

```
$ git flow init
Which branch should be used for bringing forth production releases?
   - develop
   - master
Branch name for production releases: [master] 

Which branch should be used for integration of the "next release"?
   - develop
Branch name for "next release" development: [develop] 

How to name your supporting branch prefixes?
Feature branches? [feature/]
Release branches? [release/]
Hotfix branches? [hotfix/]
Support branches? [support/]
Version tag prefix? []
Hooks and filters directory? [/home/tpocreau/wk/git-flow/.git/hooks] 
```

## Workshop

![model](./git-flow.png)

### Feature workflow

git-flow makes it easy to work on multiple features at the same time by using feature branches. To start one, use feature start with the name of your new feature (in this case, “hello-world”):

    $ git flow feature start hello-world
    Switched to a new branch 'feature/hello-world'

Summary of actions:
- A new branch 'feature/hello-world' was created, based on 'develop'
- You are now on branch 'feature/hello-world'

Now, start committing on your feature. When done, use:

     git flow feature finish hello-world

A feature branch was created and you’re automatically switched to it. Implement your feature in this branch while using git like you normally would. When you’re finished, use feature finish:

    $ git flow feature finish hello-world
    Switched to branch 'develop'
    Updating 9060376..00bafe4
    Fast-forward
     hello-world.txt | 1 +
     1 file changed, 1 insertion(+)
     create mode 100644 hello-world.txt
    Deleted branch feature/hello-world (was 00bafe4).

Summary of actions:
- The feature branch 'feature/hello-world' was merged into 'develop'
- Feature branch 'feature/hello-world' has been removed
- You are now on branch 'develop'

Your feature branch will be merged and you’re taken back to your develop branch. Internally, git-flow used `git merge --no-ff feature/hello-world` to make sure you don’t lose any historical information about your feature branch before it is removed.

### Release workflow
To start a release process, run the following commands :

    $ git flow release start 1.0.1
    Switched to a new branch 'release/1.0.1'
    
    Summary of actions:
    - A new branch 'release/1.0.1' was created, based on 'develop'
    - You are now on branch 'release/1.0.1'
    
    Follow-up actions:
    - Bump the version number now!
    - Start committing last-minute fixes in preparing your release
    - When done, run:
    
         git flow release finish '1.0.1'

Create a commit on the release branch to update the `CHANGELOG.md`
Once the QA validation is done, then run the following commands :


    $ VERSION=1.0.1
    $ TAG=${VERSION}-$(date +%Y%m%d%H%M%S)
    $ git flow release finish ${VERSION} -F -T "$TAG" -m "Release ${VERSION}" --pushproduction --pushdevelop --pushtag
    Switched to branch 'master'
    Merge made by the 'recursive' strategy.
     hello-world.txt | 1 +
     1 file changed, 1 insertion(+)
     create mode 100644 hello-world.txt
    Deleted branch release/1.0.1 (was 1b26f7c).
    
    Summary of actions:
    - Latest objects have been fetched from 'origin'
    - Release branch has been merged into 'master'
    - The release was tagged '1.0.1'
    - Release branch has been back-merged into 'develop'
    - Release branch 'release/1.0.1' has been deleted

A CI build should be triggered on the tag creation. See [using tags on Jenkins Pipeline](https://jenkins.io/blog/2018/05/16/pipelines-with-git-tags/).
The artifacts generated should use `./version.sh` version.

### Hotfix workflow

Because you keep your master branch always in sync with the code that’s on production, you’ll be able to quickly fix any issues on production.

For example, if your assets aren’t loading on production, you’d roll back your deploy and start a hotfix branch:

    $ git flow hotfix start assets
    Switched to a new branch 'hotfix/assets'

Summary of actions:
- A new branch 'hotfix/assets' was created, based on 'master'
- You are now on branch 'hotfix/assets'

Follow-up actions:
- Bump the version number now!
- Start committing your hot fixes
- When done, run:


    git flow hotfix finish 'assets'
    
Hotfix branches are a lot like release branches, except they’re based on master instead of develop. You’re automatically switched to the new hotfix branch so you can start fixing the issue and bumping the minor version number. When you’re done, hotfix finish:

    $ git flow hotfix finish assets
    Switched to branch 'master'
    Merge made by the 'recursive' strategy.
     assets.txt | 1 +
     1 file changed, 1 insertion(+)
     create mode 100644 assets.txt
    Switched to branch 'develop'
    Merge made by the 'recursive' strategy.
     assets.txt | 1 +
     1 file changed, 1 insertion(+)
     create mode 100644 assets.txt
    Deleted branch hotfix/assets (was 08edb94).
    
    Summary of actions:
    - Latest objects have been fetched from 'origin'
    - Hotfix branch has been merged into 'master'
    - The hotfix was tagged '0.1.1'
    - Hotfix branch has been back-merged into 'develop'
    - Hotfix branch 'hotfix/assets' has been deleted

Like when finishing a release branch, the hotfix branch gets merged into both master and develop. The release is tagged and the hotfix branch is removed.
