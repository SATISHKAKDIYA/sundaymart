import axios from "axios";

const categorySave = async (name, shop_id, parent, image_path, active, id) => {
    const token = localStorage.getItem('jwt_token');
    const url = "/api/auth/category/save";
    const body = {
        name: name,
        shop_id: shop_id,
        parent: parent,
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

export default categorySave;
