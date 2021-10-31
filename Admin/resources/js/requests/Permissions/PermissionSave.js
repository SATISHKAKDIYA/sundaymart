import axios from "axios";

const permissionSave = async (urlData, id) => {
    const token = localStorage.getItem('jwt_token');
    const url = "/api/auth/permission/savepermission";
    const body = {
        url: urlData,
        id: id
    };

    const headers = {
        "Authorization": "Bearer " + token
    }

    const response = await axios({
        method: 'post',
        url: url,
        data: body,
        headers: headers
    });

    return response;
}

export default permissionSave;
