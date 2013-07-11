
# Reference

    http://developer.github.com/v3/#authentication
    http://developer.github.com/v3/users/
    http://developer.github.com/v3/users/keys/
    http://developer.github.com/v3/orgs/teams/
    http://developer.github.com/v3/orgs/members/


# users

    curl -i https://api.github.com/users/mv
    curl -i https://api.github.com/users/pahagon


    {
        "login": "pahagon",
        "id": 53920,
        "url": "https://api.github.com/users/pahagon",
        "html_url": "https://github.com/pahagon",
        "organizations_url": "https://api.github.com/users/pahagon/orgs",
        "repos_url": "https://api.github.com/users/pahagon/repos",
        "type": "User",
        "name": "Paulo Ahagon",
        "company": null,
        "email": "paulo.ahagon@gmail.com",
        "created_at": "2009-02-12T13:35:54Z",
        "updated_at": "2013-07-04T23:47:48Z",
    }


# keys

    curl -i https://api.github.com/users/mv/keys
    curl -i https://api.github.com/users/pahagon/keys
    curl -i https://api.github.com/users/wikka/keys


# Repos

    # public
    curl -i https://api.github.com/orgs/Baby-com-br/repos

    # private (must authenticate using your user account)
    curl -u "mv" -i https://api.github.com/orgs/Baby-com-br/repos


# Teams

    curl -u mv -i https://api.github.com/orgs/Baby-com-br/teams
    curl -u mv -i https://api.github.com/orgs/Baby-com-br/members | grep login



