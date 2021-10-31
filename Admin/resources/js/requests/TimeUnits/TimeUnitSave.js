import axios from "axios";

const timeUnitSave = async (name, shop_id, sort, active, id) => {
    const token = localStorage.getItem('jwt_token');
    const url = "/api/auth/time-unit/save";
    const body = {
        name: name,
        shop_id: shop_id,
        sort: sort,
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

export default timeUnitSave;
