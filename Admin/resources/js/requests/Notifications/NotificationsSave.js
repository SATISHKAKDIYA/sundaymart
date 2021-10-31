import axios from "axios";

const notificationsSave = async (title, description, has_image, image_url, send_time, id_shop, active, id) => {
    const token = localStorage.getItem('jwt_token');
    const url = "/api/auth/notification/save";
    const body = {
        title: title,
        description: description,
        has_image: has_image,
        image_url: image_url,
        send_time: send_time,
        id_shop: id_shop,
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

export default notificationsSave;
