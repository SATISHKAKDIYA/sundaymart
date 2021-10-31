import axios from "axios";

const extrasSave = async (extra_group_id, name, description, image_url, price, quantity, background_color, active, id) => {
    const token = localStorage.getItem('jwt_token');
    const url = "/api/auth/extra/save";
    const body = {
        name: name,
        description: description,
        image_url: image_url,
        active: active,
        extra_group_id: extra_group_id,
        price: price,
        background_color: background_color,
        quantity: quantity,
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

export default extrasSave;
