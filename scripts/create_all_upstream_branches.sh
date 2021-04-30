function setup_git_user() {
  git config --global user.email ${USER_EMAIL}
  git config --global user.name ${USER_NAME}
}

function create_all_upstream_branches()
{
    # Keep track of where Travis put us.
    # We are on a detached head, and we need to be able to go back to it.
    local build_head=$(git rev-parse HEAD)

    # Fetch all the remote branches. Travis clones with `--depth`, which
    # implies `--single-branch`, so we need to overwrite remote.upstream.fetch to
    # do that.
    git config --replace-all remote.upstream.fetch +refs/heads/*:refs/remotes/upstream/*
    git fetch
    # optionally, we can also fetch the tags
    git fetch --tags

    # create the tacking branches
    for branch in $(git branch -r|grep -v HEAD) ; do
        git checkout -qf ${branch#upstream/}
    done

    # finally, go back to where we were at the beginning
    git checkout ${build_head}
}