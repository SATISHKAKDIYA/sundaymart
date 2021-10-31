import axios from "axios";

const brandsCategorySave = async (name, active, id) => {
    const token = localStorage.getItem('jwt_token');
    const url = "/api/auth/brand-category/save";
    const body = {
        name: name,
        active: active,
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

export default brandsCategorySave;
