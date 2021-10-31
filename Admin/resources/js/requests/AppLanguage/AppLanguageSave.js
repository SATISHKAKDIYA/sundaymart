import axios from "axios";

const appLanguageSave = async (id_lang, name, id_param) => {
    const token = localStorage.getItem('jwt_token');
    const url = "/api/auth/app-language/save";
    const body = {
        id_lang: id_lang,
        name: name,
        id_param: id_param
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

export default appLanguageSave;
