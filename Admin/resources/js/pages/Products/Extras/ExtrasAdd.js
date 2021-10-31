import React from 'react';
import {PageHeader, Card, Checkbox, Form, Input, InputNumber, Radio, Select, Upload, Button} from "antd";
import {PlusOutlined} from "@ant-design/icons";
import {SketchPicker} from "react-color";
import extraGroupActive from "../../../requests/ExtrasGroups/ExtrasGroupActive";
import extrasSave from "../../../requests/Extras/ExtrasSave";
import languageActive from "../../../requests/Language/LanguageActive";
import extrasGet from "../../../requests/Extras/ExtrasGet";

const {Option} = Select;
const {TextArea} = Input;

class ExtrasAdd extends React.Component {
    formRef = React.createRef();

    constructor(props) {
        super(props);

        this.state = {
            extras_types: [],
            extras_type: -1,
            extra_names: {},
            active_extra: true,
            language: "en",
            languages: [],
            extras_group_type: -1,
            extra_descriptions: {},
            background_color: "",
            extras_group: [],
            extras_group_id: -1,
            id: props.id,
            edit: props.id > 0 ? true : false,
            product_id: props.product_id,
            fileList: []
        };

        this.onChangeProductExtraName = this.onChangeProductExtraName.bind(this);
        this.onChangeExtraDescription = this.onChangeExtraDescription.bind(this);
        this.handleChangeBackgroundColor = this.handleChangeBackgroundColor.bind(this);
        this.onChangeLanguage = this.onChangeLanguage.bind(this);
        this.handleChangeBackgroundColor = this.handleChangeBackgroundColor.bind(this);
        this.handleChangeFileList = this.handleChangeFileList.bind(this);
        this.onChangeExtrasGroup = this.onChangeExtrasGroup.bind(this);

        this.getActiveExtrasGroup(props.product_id);
        this.getActiveLanguages();
    }

    componentDidMount() {
        if (this.state.edit)
            setTimeout(() => this.getInfoById(this.state.id), 1000);
    }

    getInfoById = async (id) => {
        let data = await extrasGet(id);
        if (data.data.success) {
            let extras = data.data.data.extras;
            let extras_language = data.data.data.extras_language;

            var namesArray = this.state.extra_names;
            var descriptionsArray = this.state.extra_descriptions;
            for (let i = 0; i < extras_language.length; i++) {
                var lang = extras_language[i].short_name;
                namesArray[lang] = extras_language[i].name;
                descriptionsArray[lang] = extras_language[i].description;
            }

            var fileListArray = [];
            fileListArray.push({
                uid: -1,
                name: extras.image_url,
                status: 'done',
                url: '/uploads/' + extras.image_url,
            });

            this.setState({
                active_extra: extras.active == 1 ? true : false,
                extra_names: namesArray,
                extra_descriptions: descriptionsArray,
                background_color: extras.background_color,
                fileList: fileListArray,
                extras_group_id: extras.id_extra_group,
                extras_group_type: extras.type
            });

            this.formRef.current.setFieldsValue({
                extras_group: extras.id_extra_group,
                extra_name: namesArray[this.state.language],
                description: namesArray[this.state.language],
                price_extras: extras.price,
                quantity: extras.quantity,
                dragger: fileListArray
            });
        }
    }

    getActiveLanguages = async () => {
        let data = await languageActive();
        if (data.data.success == 1 && data.data.data.length > 0) {
            this.setState({
                languages: data.data.data,
                language: data.data.data[0].short_name
            });

            var namesArray = this.state.extra_names;
            var descriptionArray = this.state.extra_descriptions;

            for (let i = 0; i < data.data.data.length; i++) {
                var lang = data.data.data[i].short_name;
                namesArray[lang] = "";
                descriptionArray[lang] = "";
            }

            this.setState({
                extra_names: namesArray,
                extra_descriptions: descriptionArray,
            });
        }
    }

    onFinish = async (values) => {
        var img_url = "";
        if (this.state.fileList.length > 0)
            img_url = this.state.fileList[0].name;
        let data = await extrasSave(this.state.extras_group_id, this.state.extra_names, this.state.extra_descriptions, img_url, values.price_extras, values.quantity, this.state.background_color, this.state.active_extra, this.state.id);

        if (data.data.success == 1) {
            this.setState({
                id: data.data.data.id
            });

            this.props.onSave();
        }
    }

    getActiveExtrasGroup = async (product_id) => {
        let data = await extraGroupActive(product_id);
        if (data.data.success == 1 && data.data.data.length > 0) {
            this.setState({
                extras_group: data.data.data,
                extras_group_type: data.data.data[0].type,
                extras_group_id: data.data.data[0].id
            });

            this.formRef.current.setFieldsValue({
                extras_group: data.data.data[0].id
            });
        }
    }

    onFinishFailed = (errorInfo) => {
    };

    onChangeProductExtraName = (e) => {
        var extraNamesArray = this.state.extra_names;

        if (typeof extraNamesArray[this.state.language] == 'undefined')
            extraNamesArray[this.state.language] = [];

        extraNamesArray[this.state.language] = e.target.value;
        this.setState({
            extra_names: extraNamesArray
        })
    }

    onChangeExtraDescription = (e) => {
        var extraDescriptionArray = this.state.extra_descriptions;

        if (typeof extraDescriptionArray[this.state.language] == 'undefined')
            extraDescriptionArray[this.state.language] = [];

        extraDescriptionArray[this.state.language] = e.target.value;
        this.setState({
            extra_descriptions: extraDescriptionArray
        })
    }

    handleChangeBackgroundColor = (color) => {
        this.setState({background_color: color.hex});
    };


    handleChangeFileList = ({fileList}) => {
        fileList = fileList.map(file => {
            if (file.response) {
                return {
                    uid: file.uid,
                    name: file.response.name,
                    status: 'done',
                    url: '/uploads/' + file.response.name,
                };
            }
            return file;
        });

        this.setState({fileList});
    };


    handleCancel = () => this.setState({previewVisible: false});

    getBase64 = (file) => {
        return new Promise((resolve, reject) => {
            const reader = new FileReader();
            reader.readAsDataURL(file);
            reader.onload = () => resolve(reader.result);
            reader.onerror = error => reject(error);
        });
    }

    handlePreview = async file => {
        if (!file.url && !file.preview) {
            file.preview = await this.getBase64(file.originFileObj);
        }

        this.setState({
            previewImage: file.url || file.preview,
            previewVisible: true,
            previewTitle: file.name || file.url.substring(file.url.lastIndexOf('/') + 1),
        });
    };

    normFile = (e) => {
        if (Array.isArray(e)) {
            return e;
        }

        return e && e.fileList;
    };

    changeStatus = (e) => {
        this.setState({
            active_extra: e.target.checked
        });
    }

    onChangeLanguage = (e) => {// 99 805 5856
        let lang = e.target.value;
        this.setState({
            language: lang
        });

        this.formRef.current.setFieldsValue({
            extra_name: this.state.extra_names[lang],
            description: this.state.extra_descriptions[lang],
        });
    };

    onChangeExtrasGroup = (e) => {
        var index = this.state.extras_group.findIndex((item) => item.id == e);

        this.setState({
            extras_group_type:this.state.extras_group[index].type,
            extras_group_id: e
        });
    }

    render() {
        return (
            <PageHeader
                onBack={() => this.props.onSave()}
                className="site-page-header"
                title={this.state.edit ? "Product extras Edit" : "Product extras Add"}
            >
                <Form
                    ref={this.formRef}
                    name="basic"
                    initialValues={{}}
                    layout="vertical"
                    onFinish={this.onFinish}
                    onFinishFailed={this.onFinishFailed}
                >
                    <Card style={{marginTop: '20px'}} title="Product extras">
                        <div className="row">
                            <div className="col-md-12 col-sm-12">
                                <Radio.Group value={this.state.language}
                                             onChange={this.onChangeLanguage}
                                             className="float-right">
                                    {
                                        this.state.languages.map((item) => {
                                            return (
                                                <Radio.Button value={item.short_name}
                                                              key={item.short_name}>{item.name}</Radio.Button>);
                                        })
                                    }
                                </Radio.Group>
                            </div>
                        </div>
                        <div className="row">
                            <div className="col-md-4 col-sm-12">
                                <Form.Item name="extras_group"
                                           label="Extras group"
                                           tooltip="Select extras group">
                                    <Select placeholder="Select extras group"
                                            onChange={this.onChangeExtrasGroup}>
                                        {
                                            this.state.extras_group.map((item) => {
                                                return (
                                                    <Option value={item.id}
                                                            key={item.id}>{item.name}</Option>);
                                            })
                                        }
                                    </Select>
                                </Form.Item>
                            </div>
                            <div className="col-md-4 col-sm-12">
                                <Form.Item label="Product extras name"
                                           name="extra_name"
                                           rules={[{
                                               required: true,
                                               message: 'Missing product extras name'
                                           }]}
                                           tooltip="Enter product extras name">
                                    <Input placeholder="Product extras name"
                                           onChange={this.onChangeProductExtraName}/>
                                </Form.Item>
                            </div>
                            <div className="col-md-4 col-sm-12">
                                <Form.Item
                                    label="Description"
                                    name="description"
                                    rules={[{
                                        required: true,
                                        message: 'Missing extras description'
                                    }]}
                                    tooltip="Enter extras description"
                                >
                                    <TextArea showCount maxLength={100}
                                              onChange={this.onChangeExtraDescription}/>
                                </Form.Item>
                            </div>
                            {
                                this.state.extras_group_type == 1 && (
                                    <div className="col-md-3 col-sm-6">
                                        <Form.Item label="Extras image"
                                                   tooltip="Upload extras image">
                                            <Form.Item name="dragger"
                                                       valuePropName="fileList"
                                                       getValueFromEvent={this.normFile}
                                                       rules={[{
                                                           required: true,
                                                           message: 'Missing extras image'
                                                       }]}
                                                       noStyle>
                                                <Upload
                                                    action="/api/auth/upload"
                                                    listType="picture-card"
                                                    fileList={this.state.fileList}
                                                    defaultFileList={this.state.fileList}
                                                    onPreview={this.handlePreview}
                                                    onChange={this.handleChangeFileList}
                                                >
                                                    {this.state.fileList.length >= 1 ? null : (
                                                        <div>
                                                            <PlusOutlined/>
                                                            <div
                                                                style={{marginTop: 8}}>Upload
                                                            </div>
                                                        </div>
                                                    )}
                                                </Upload>
                                            </Form.Item>
                                        </Form.Item>
                                    </div>
                                )
                            }
                            {
                                this.state.extras_group_type == 2 && (
                                    <div className="col-md-3 col-sm-6">
                                        <Form.Item label="Background color"
                                                   name="background_color"
                                                   rules={[{
                                                       required: true,
                                                       message: 'Missing background color'
                                                   }]}
                                                   tooltip="Select background color">
                                            <SketchPicker
                                                color={this.state.background_color}
                                                onChangeComplete={this.handleChangeBackgroundColor}/>
                                        </Form.Item>
                                    </div>
                                )
                            }
                            <div className="col-md-3 col-sm-6">
                                <Form.Item label="Quantity" name="quantity"
                                           rules={[{
                                               required: true,
                                               message: 'Missing quantity'
                                           }]}
                                           tooltip="Enter quantity">
                                    <InputNumber placeholder="quantity"/>
                                </Form.Item>
                            </div>
                            <div className="col-md-3 col-sm-6">
                                <Form.Item label="Price" name="price_extras"
                                           rules={[{
                                               required: true,
                                               message: 'Missing price'
                                           }]}
                                           tooltip="Enter price">
                                    <InputNumber placeholder="Price"/>
                                </Form.Item>
                            </div>
                            <div className="col-md-3 col-sm-6">
                                <Form.Item label="Status" name="active"
                                           tooltip="Uncheck if product is inactive">
                                    <Checkbox checked={this.state.active_extra}
                                              onChange={this.changeStatus}>{this.state.active_extra ? "Active" : "Inactive"}</Checkbox>
                                </Form.Item>
                            </div>
                        </div>
                    </Card>
                    <Form.Item>
                        <Button type="primary" className="btn-success"
                                style={{marginTop: '40px'}}
                                htmlType="submit">Save</Button>
                    </Form.Item>
                </Form>
            </PageHeader>);
    }
}

export default ExtrasAdd;
