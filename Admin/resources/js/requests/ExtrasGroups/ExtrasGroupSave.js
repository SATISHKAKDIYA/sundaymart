import axios from "axios";

const extrasGroupSave = async (product_id, name, type, active, id) => {
    const token = localStorage.getItem('jwt_token');
    const url = "/api/auth/extra-group/save";
    const body = {
        name: name,
        type: type,
        active: active,
        product_id: product_id,
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

export default extrasGroupSave;
