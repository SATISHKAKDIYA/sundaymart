import axios from "axios";

const adminSave = async (name, surname, email, phone, password, shop_id, role_id, image_path, active, id) => {
    const token = localStorage.getItem('jwt_token');
    const url = "/api/auth/admin/save";
    const body = {
        name: name,
        surname: surname,
        email: email,
        phone: phone,
        password: password,
        shop_id: shop_id,
        role_id: role_id,
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

export default adminSave;
