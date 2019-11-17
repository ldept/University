bool my_access(struct stat* statbuf, int mode)
{
    const int rwx = ((mode & R_OK != 0) << 2)
                  | ((mode & W_OK != 0) << 1)
                  |  (mode & X_OK != 0);

    if (statbuf->st_uid == getuid())
        return (((statbuf->st_mode >> 6) & rwx) ^ rwx) == 0;


    gid_t gids[SIZE];
    const int gids_count = getgroups(SIZE, gids);

    for (int i = 0; i < gids_count; i++)
    {
        if (gids[i] == statbuf->st_gid)
            return (((statbuf->st_mode >> 3) & rwx) ^ rwx) == 0;
    }

    return ((statbuf->st_mode & rwx) ^ rwx) == 0;
}