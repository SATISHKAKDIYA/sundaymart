import axios from "axios";

const paymentStatusActive = async () => {
    const token = localStorage.getItem('jwt_token');
    const url = "/api/auth/payment/status/active";
    const body = {};

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

export default paymentStatusActive;
