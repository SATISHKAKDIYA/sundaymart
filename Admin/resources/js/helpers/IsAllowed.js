export const  isAllowed = (path) => {
    let localData = localStorage.getItem('permission') ?? "[]";
    const permissions = localData != 'undefined' ? JSON.parse(localData) : [];
    return permissions != null && permissions.findIndex((item) => item.url == path) > -1;
}
