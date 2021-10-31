import axios from "axios";

const brandSave = async (brand_category, name, shop_id, image_path, active, id) => {
    const token = localStorage.getItem('jwt_token');
    const url = "/api/auth/brand/save";
    const body = {
        id_brand_category: brand_category,
        name: name,
        shop_id: shop_id,
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

export default brandSave;
