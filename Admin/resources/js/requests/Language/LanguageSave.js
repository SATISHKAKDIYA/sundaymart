import axios from "axios";

const languageSave = async (name, short_code, image_path, active, id) => {
    const token = localStorage.getItem('jwt_token');
    const url = "/api/auth/language/save";
    const body = {
        name: name,
        short_code: short_code,
        image_path: image_path,
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

export default languageSave;
