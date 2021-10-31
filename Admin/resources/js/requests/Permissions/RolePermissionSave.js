import axios from "axios";

const rolePermissionSave = async (id, name, value) => {
    const token = localStorage.getItem('jwt_token');
    const url = "/api/auth/permission/save";
    const body = {
        name: name,
        value: value,
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

export default rolePermissionSave;
