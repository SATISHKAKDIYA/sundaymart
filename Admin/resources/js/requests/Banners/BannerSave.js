import axios from "axios";

const bannerSave = async (name, description, sub_titles, button_text, shop_id, image_path, position, title_color,
                          button_color, indicator_color, background_color, products, active, id) => {
    const token = localStorage.getItem('jwt_token');
    const url = "/api/auth/banner/save";
    const body = {
        name: name,
        description: description,
        sub_title: sub_titles,
        button_text: button_text,
        shop_id: shop_id,
        image_path: image_path,
        position: position,
        title_color: title_color,
        button_color: button_color,
        indicator_color: indicator_color,
        background_color: background_color,
        products: products,
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

export default bannerSave;
