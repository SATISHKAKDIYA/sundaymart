import React from 'react';
import PageLayout from "../../layouts/PageLayout";
import * as moment from 'moment';
import {
    Breadcrumb,
    Layout,
    PageHeader,
    Form,
    Input,
    Button,
    InputNumber,
    Upload,
    TimePicker,
    Radio,
    Spin,
    Modal,
    Select, Checkbox
} from "antd";
import {Link} from 'react-router-dom';
import {InfoCircleOutlined, InboxOutlined, ShopOutlined, PlusOutlined} from '@ant-design/icons';
import GoogleMapReact from 'google-map-react';
import languageActive from "../../requests/Language/LanguageActive";
import shopSave from "../../requests/Shops/ShopSave";
import shopGet from "../../requests/Shops/ShopGet";
import shopsCategoryActive from "../../requests/ShopCategories/ShopsCategoryActive";

const {Option} = Select;
const {Content} = Layout;
const {TextArea} = Input;

const AnyReactComponent = ({lat, lng, text}) => <div><ShopOutlined style={{fontSize: '32px', color: 'red'}}/></div>;

class ShopAdd extends React.Component {
    formRef = React.createRef();

    constructor(props) {
        super(props);

        this.state = {
            latitude: 59.95,
            longitude: 30.33,
            language: "en",
            languages: [],
            shopsCategories: [],
            names: {},
            descriptions: {},
            infos: {},
            addresses: {},
            previewImage: "",
            previewVisible: false,
            previewTitle: "",
            fileList: [],
            fileListBackground: [],
            open_hours: "",
            close_hours: "",
            active: true,
            is_closed: false,
            id: props.location.state ? props.location.state.id : 0,
            edit: props.location.state ? props.location.state.edit : false
        }

        this.onClickMap = this.onClickMap.bind(this);
        this.onChangeLanguage = this.onChangeLanguage.bind(this);
        this.getActiveLanguages = this.getActiveLanguages.bind(this);
        this.onChangeName = this.onChangeName.bind(this);
        this.onChangeDescription = this.onChangeDescription.bind(this);
        this.onChangeAddress = this.onChangeAddress.bind(this);
        this.onChangeInfo = this.onChangeInfo.bind(this);
        this.onChangeOpenHours = this.onChangeOpenHours.bind(this);
        this.onChangeCloseHours = this.onChangeCloseHours.bind(this);
        this.changeStatus = this.changeStatus.bind(this);
        this.changeClosed = this.changeClosed.bind(this);

        this.getActiveLanguages();
        this.getActiveShopCategories();
    }

    componentDidMount() {
        if (this.state.edit)
            setTimeout(() => this.getInfoById(this.state.id), 1000);
    }

    getInfoById = async (id) => {
        let data = await shopGet(id);
        if (data.data.success) {
            let shops = data.data.data.shop;
            let shops_language = data.data.data.shops_language;

            var namesArray = this.state.names;
            var descriptionsArray = this.state.descriptions;
            var addressesArray = this.state.addresses;
            var infoArray = this.state.infos;
            for (let i = 0; i < shops_language.length; i++) {
                var lang = shops_language[i].short_name;
                descriptionsArray[lang] = shops_language[i].description;
                namesArray[lang] = shops_language[i].name;
                addressesArray[lang] = shops_language[i].address;
                infoArray[lang] = shops_language[i].info;
            }

            var phone = shops.phone.split(" ");
            var mobile = shops.mobile.split(" ");

            this.setState({
                names: namesArray,
                descriptions: descriptionsArray,
                addresses: addressesArray,
                infos: infoArray,
                fileList: [
                    {
                        uid: '-1',
                        name: shops.logo_url,
                        status: 'done',
                        url: '/uploads/' + shops.logo_url,
                    },
                ],
                fileListBackground: [
                    {
                        uid: '-2',
                        name: shops.backimage_url,
                        status: 'done',
                        url: '/uploads/' + shops.backimage_url,
                    },
                ],
                open_hours: shops.open_hour,
                close_hours: shops.close_hour,
                active: shops.active == 1 ? true : false,
                is_closed: shops.is_closed == 1 ? true : false,
            });


            this.formRef.current.setFieldsValue({
                name: namesArray[this.state.language],
                description: descriptionsArray[this.state.language],
                address: addressesArray[this.state.language],
                info: infoArray[this.state.language],
                prefix_phone: phone[0],
                phone: phone[1],
                prefix_mobile: mobile[0],
                mobile: mobile[1],
                dragger: this.state.fileList,
                dragger2: this.state.fileListBackground,
                latitude: shops.latitude,
                longitude: shops.longtitude,
                commission: shops.admin_percentage,
                delivery_fee: shops.delivery_price,
                delivery_range: shops.delivery_range,
                tax: shops.tax,
                delivery_type: shops.delivery_type.toString(),
                feature_type: shops.show_type.toString(),
                open_hours: moment(shops.open_hour, 'HH:mm:ss'),
                close_hours: moment(shops.close_hour, 'HH:mm:ss'),
            });
        }
    }

    getActiveShopCategories = async () => {
        let data = await shopsCategoryActive();
        if (data.data.success == 1 && data.data.data.length > 0) {
            this.setState({
                shopsCategories: data.data.data,
            });

            if (this.formRef.current != null)
                this.formRef.current.setFieldsValue({
                    shop_categories: data.data.data[0].id,
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

            var namesArray = this.state.names;
            var descriptionsArray = this.state.descriptions;
            var addressesArray = this.state.addresses;
            var infoArray = this.state.infos;
            for (let i = 0; i < data.data.data.length; i++) {
                var lang = data.data.data[i].short_name;
                descriptionsArray[lang] = "";
                namesArray[lang] = "";
                addressesArray[lang] = "";
                infoArray[lang] = "";
            }

            this.setState({
                names: namesArray,
                descriptions: descriptionsArray,
                addresses: addressesArray,
                infos: infoArray
            });
        }
    }

    onChangeOpenHours = (time, timeString) => {
        this.setState({
            open_hours: timeString
        });
    }

    onChangeCloseHours = (time, timeString) => {
        this.setState({
            close_hours: timeString
        });
    }

    onChangeName = (e) => {
        var namesArray = this.state.names;
        namesArray[this.state.language] = e.target.value;
        this.setState({
            names: namesArray
        });
    }

    onChangeDescription = (e) => {
        var descriptionArray = this.state.descriptions;
        descriptionArray[this.state.language] = e.target.value;
        this.setState({
            descriptions: descriptionArray
        });
    }

    onChangeAddress = (e) => {
        var addressesArray = this.state.addresses;
        addressesArray[this.state.language] = e.target.value;
        this.setState({
            addresses: addressesArray
        });
    }

    onChangeInfo = (e) => {
        var infosArray = this.state.infos;
        infosArray[this.state.language] = e.target.value;
        this.setState({
            infos: infosArray
        });
    }

    onFinish = async (values) => {
        var params = {
            names: this.state.names,
            descriptions: this.state.descriptions,
            addresses: this.state.addresses,
            infos: this.state.infos,
            latitude: this.state.latitude,
            longitude: this.state.longitude,
            commission: values.commission,
            delivery_fee: values.delivery_fee,
            delivery_range: values.delivery_range,
            mobile: values.prefix_mobile + " " + values.mobile,
            phone: values.prefix_phone + " " + values.phone,
            tax: values.tax,
            delivery_type: values.delivery_type,
            feature_type: values.feature_type,
            close_hours: this.state.close_hours,
            open_hours: this.state.open_hours,
            active: this.state.active,
            is_closed: this.state.is_closed,
            logo_url: this.state.fileList[0].name,
            back_image_url: this.state.fileListBackground[0].name,
            id: this.state.id,
            shop_categories_id: values.shop_categories
        };

        let data = await shopSave(params);
        if (data.data.success == 1)
            window.history.back();
    };

    onFinishFailed = (errorInfo) => {
    };

    normFile = (e) => {
        if (Array.isArray(e)) {
            return e;
        }

        return e && e.fileList;
    };

    onClickMap = (position) => {
        this.setState({
            latitude: position.lat,
            longitude: position.lng
        })
    }

    onChangeLanguage = (e) => {// 99 805 5856
        let lang = e.target.value;
        this.setState({
            language: lang
        });

        this.formRef.current.setFieldsValue({
            name: this.state.names[lang],
            description: this.state.descriptions[lang],
            address: this.state.addresses[lang],
            info: this.state.infos[lang]
        });
    };

    getBase64 = (file) => {
        return new Promise((resolve, reject) => {
            const reader = new FileReader();
            reader.readAsDataURL(file);
            reader.onload = () => resolve(reader.result);
            reader.onerror = error => reject(error);
        });
    }

    handleCancel = () => this.setState({previewVisible: false});

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

    handleChange = ({fileList}) => {
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

    handleChangeBackground = ({fileList}) => {
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

        this.setState({fileListBackground: fileList});
    };

    changeStatus = (e) => {
        this.setState({
            active: e.target.checked
        });
    }


    changeClosed = (e) => {
        this.setState({
            is_closed: e.target.checked
        });
    }

    render() {
        return (
            <PageLayout>
                <Breadcrumb style={{margin: '16px 0'}}>
                    <Breadcrumb.Item><Link to="/shops" className="nav-text">Shops</Link></Breadcrumb.Item>
                    <Breadcrumb.Item>{this.state.edit ? "Edit" : "Add"}</Breadcrumb.Item>
                </Breadcrumb>
                <PageHeader
                    onBack={() => window.history.back()}
                    className="site-page-header"
                    title={this.state.edit ? "Shops Edit" : "Shops Add"}
                >
                    <Content
                        className="site-layout-background padding-20">
                        {
                            (this.state.shopsCategories.length > 0) ? (<Form
                                ref={this.formRef}
                                name="basic"
                                initialValues={{
                                    prefix_mobile: "+1",
                                    prefix_phone: "+1",
                                    feature_type: "1",
                                    delivery_type: "1",
                                    shop_categories: this.state.shopsCategories[0].id
                                }}
                                layout="vertical"
                                onFinish={this.onFinish}
                                onFinishFailed={this.onFinishFailed}
                            >
                                <div className="row">
                                    <div className="col-md-12 col-sm-12">
                                        <Radio.Group value={this.state.language} onChange={this.onChangeLanguage}
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
                                    <div className="col-md-6 col-sm-12">
                                        <Form.Item label="Shop categories" name="shop_categories"
                                                   rules={[{required: true, message: 'Missing shop categories'}]}
                                                   tooltip="Select shop categories">
                                            <Select placeholder="Select shop categories">
                                                {
                                                    this.state.shopsCategories.map((item) => {
                                                        return (
                                                            <Option value={item.id}
                                                                    key={item.id}>{item.name}</Option>);
                                                    })
                                                }
                                            </Select>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-6 col-sm-12">
                                        <Form.Item label="Name" name="name"
                                                   rules={[{required: true, message: 'Missing shop name'}]}
                                                   tooltip="Enter shop name">
                                            <Input placeholder="Name"
                                                   onChange={this.onChangeName}/>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-6 col-sm-12">
                                        <Form.Item
                                            label="Description"
                                            name="description"
                                            rules={[{required: true, message: 'Missing shop description'}]}
                                            tooltip="Enter shop description"
                                        >
                                            <TextArea showCount maxLength={100} onChange={this.onChangeDescription}/>
                                        </Form.Item>
                                    </div>

                                    <div className="col-md-6 col-sm-12">
                                        <Form.Item
                                            label="Info"
                                            name="info"
                                            tooltip="Enter shop info"
                                        >
                                            <TextArea showCount maxLength={100} onChange={this.onChangeInfo}/>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-6 col-sm-12">
                                        <Form.Item label="Address" name="address"
                                                   rules={[{required: true, message: 'Missing shop address'}]}
                                                   tooltip="Enter shop address">
                                            <Input placeholder="Address" onChange={this.onChangeAddress}/>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-6 col-sm-12">
                                        <Form.Item label="Phone" name="phone"
                                                   rules={[{required: true, message: 'Missing shop phone'}]}
                                                   tooltip="Enter shop phone">
                                            <Input addonBefore={(<Form.Item name="prefix_phone" noStyle>
                                                <Select
                                                    style={{
                                                        width: 70,
                                                    }}
                                                >
                                                    <Option value="+1">+1</Option>
                                                    <Option value="+8">+8</Option>
                                                </Select>
                                            </Form.Item>)} placeholder="Phone"/>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-6 col-sm-12">
                                        <Form.Item label="Mobile" name="mobile"
                                                   rules={[{required: true, message: 'Missing shop mobile phone'}]}
                                                   tooltip="Enter shop mobile phone">
                                            <Input placeholder="Mobile"
                                                   addonBefore={(<Form.Item name="prefix_mobile" noStyle>
                                                       <Select
                                                           style={{
                                                               width: 70,
                                                           }}
                                                       >
                                                           <Option value="+1">+1</Option>
                                                           <Option value="+8">+8</Option>
                                                       </Select>
                                                   </Form.Item>)}/>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-3 col-sm-6">
                                        <Form.Item label="Commission" name="commission"
                                                   rules={[{required: true, message: 'Missing shop admin commission'}]}
                                                   tooltip="Enter shop commission">
                                            <InputNumber placeholder="Commission"/>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-3 col-sm-6">
                                        <Form.Item label="Tax" name="tax"
                                                   rules={[{required: true, message: 'Missing shop tax'}]}
                                                   tooltip="Enter shop tax">
                                            <InputNumber placeholder="Tax"/>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-3 col-sm-6">
                                        <Form.Item label="Delivery fee" name="delivery_fee"
                                                   rules={[{required: true, message: 'Missing shop delivery fee'}]}
                                                   tooltip="Enter shop delivery fee">
                                            <InputNumber placeholder="Delivery fee"/>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-3 col-sm-6">
                                        <Form.Item label="Delivery range" name="delivery_range"
                                                   rules={[{required: true, message: 'Missing shop delivery range'}]}
                                                   tooltip="Enter shop delivery range">
                                            <InputNumber placeholder="Delivery range"/>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-3 col-sm-6">
                                        <Form.Item label="Logo" tooltip="Upload shop logo">
                                            <Form.Item name="dragger" valuePropName="fileList"
                                                       getValueFromEvent={this.normFile}
                                                       rules={[{
                                                           required: true,
                                                           message: 'Missing shop logo image'
                                                       }]}
                                                       noStyle>
                                                <Upload
                                                    action="/api/auth/upload"
                                                    listType="picture-card"
                                                    fileList={this.state.fileList}
                                                    defaultFileList={this.state.fileList}
                                                    onPreview={this.handlePreview}
                                                    onChange={this.handleChange}
                                                >
                                                    {this.state.fileList.length >= 1 ? null : (
                                                        <div>
                                                            <PlusOutlined/>
                                                            <div style={{marginTop: 8}}>Upload</div>
                                                        </div>
                                                    )}
                                                </Upload>
                                            </Form.Item>
                                            <Modal
                                                visible={this.state.previewVisible}
                                                title={this.state.previewTitle}
                                                footer={null}
                                                onCancel={this.handleCancel}
                                            >
                                                <img alt="example" style={{width: '100%'}}
                                                     src={this.state.previewImage}/>
                                            </Modal>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-3 col-sm-6">
                                        <Form.Item label="Background image" tooltip="Upload shop background image">
                                            <Form.Item name="dragger2" valuePropName="fileListBackground"
                                                       getValueFromEvent={this.normFile}
                                                       rules={[{
                                                           required: true,
                                                           message: 'Missing shop background image'
                                                       }]}
                                                       noStyle>
                                                <Upload
                                                    action="/api/auth/upload"
                                                    listType="picture-card"
                                                    fileList={this.state.fileListBackground}
                                                    defaultFileList={this.state.fileListBackground}
                                                    onPreview={this.handlePreview}
                                                    onChange={this.handleChangeBackground}
                                                >
                                                    {this.state.fileListBackground.length >= 1 ? null : (
                                                        <div>
                                                            <PlusOutlined/>
                                                            <div style={{marginTop: 8}}>Upload</div>
                                                        </div>
                                                    )}
                                                </Upload>
                                            </Form.Item>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-3 col-sm-6">
                                        <Form.Item name="open_hours" label="Open hours"
                                                   tooltip="Enter shop open hours"
                                                   rules={[{required: true, message: 'Missing shop open hours'}]}>
                                            <TimePicker onChange={this.onChangeOpenHours}/>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-3 col-sm-6">
                                        <Form.Item name="close_hours" label="Close hours"
                                                   tooltip="Enter shop close hours"
                                                   rules={[{required: true, message: 'Missing shop close hours'}]}>
                                            <TimePicker onChange={this.onChangeCloseHours}/>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-3 col-sm-6">
                                        <Form.Item name="delivery_type" label="Delivery type"
                                                   tooltip="Enter shop delivery type">
                                            <Radio.Group>
                                                <Radio value="1">Delivery</Radio>
                                                <Radio value="2">Pickup</Radio>
                                                <Radio value="3">Delivery & Pickup</Radio>
                                            </Radio.Group>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-3 col-sm-6">
                                        <Form.Item name="feature_type" label="Feature type"
                                                   tooltip="Enter shop feature type">
                                            <Radio.Group>
                                                <Radio value="1">Default</Radio>
                                                <Radio value="2">New</Radio>
                                                <Radio value="3">Top</Radio>
                                            </Radio.Group>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-3 col-sm-6">
                                        <Form.Item label="Status" name="active"
                                                   tooltip="Uncheck if shop is inactive">
                                            <Checkbox checked={this.state.active}
                                                      onChange={this.changeStatus}>{this.state.active ? "Active" : "Inactive"}</Checkbox>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-3 col-sm-6">
                                        <Form.Item label="Closed" name="closed"
                                                   tooltip="Check if shop is closed">
                                            <Checkbox checked={this.state.is_closed}
                                                      onChange={this.changeClosed}>{this.state.is_closed ? "Closed" : "Open"}</Checkbox>
                                        </Form.Item>
                                    </div>
                                    <div className="col-md-12 col-sm-12 mb-3" style={{height: '500px'}}>
                                        <label className="defaultLabel">Select shop location</label>
                                        <GoogleMapReact
                                            bootstrapURLKeys={{key: "AIzaSyBFsAIXWFOG2FdhUnxbO9-VsJ2LlTezE98"}}
                                            defaultCenter={{
                                                lat: 59.95,
                                                lng: 30.33
                                            }}
                                            defaultZoom={11}
                                            onClick={this.onClickMap}
                                        >
                                            <AnyReactComponent
                                                lat={this.state.latitude}
                                                lng={this.state.longitude}
                                                text="New location"
                                            />

                                        </GoogleMapReact>
                                    </div>
                                </div>

                                <Form.Item>
                                    <Button type="primary" className="btn-success" style={{marginTop: '40px'}}
                                            htmlType="submit">Save</Button>
                                </Form.Item>
                            </Form>) : (
                                <div className="d-flex flex-row justify-content-center" style={{height: '400px'}}>
                                    <Spin style={{marginTop: 'auto', marginBottom: 'auto'}} size="large"/>
                                </div>)
                        }
                    </Content>
                </PageHeader>
            </PageLayout>
        );
    }
}

export default ShopAdd;
