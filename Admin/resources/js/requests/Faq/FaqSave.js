import axios from "axios";

const faqSave = async (questions, answers, shop_id, active, id) => {
    const token = localStorage.getItem('jwt_token');
    const url = "/api/auth/faq/save";
    const body = {
        questions: questions,
        answers: answers,
        id_shop: shop_id,
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

export default faqSave;
