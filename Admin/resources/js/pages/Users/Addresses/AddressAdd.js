import React from 'react';
import PageLayout from "../../../layouts/PageLayout";
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
import shopSave from "../../../requests/Shops/ShopSave";
import clientActive from "../../../requests/Clients/ClientActive";
import addressSave from "../../../requests/Address/AddressSave";

const {Option} = Select;
const {Content} = Layout;
const {TextArea} = Input;

const AnyReactComponent = ({lat, lng, text}) => <div><ShopOutlined style={{fontSize: '32px', color: 'red'}}/></div>;

class AddressAdd extends React.Component {
    formRef = React.createRef();

    constructor(props) {
        super(props);

        this.state = {
            latitude: 59.95,
            longitude: 30.33,
            clients: [],
            id: props.location.state ? props.location.state.id : 0,
            edit: props.location.state ? props.location.state.edit : false,
            client_id: props.location.state ? props.location.state.client_id : -1,
        }

        this.onClickMap = this.onClickMap.bind(this);
        this.getActiveClient = this.getActiveClient.bind(this);
        this.onFinish = this.onFinish.bind(this);

        this.getActiveClient();

        if (this.state.edit)
            this.getInfoById(this.state.id);
    }

    getInfoById = async (id) => {

    }

    getActiveClient = async () => {
        let data = await clientActive();
        if (data.data.success == 1 && data.data.data.length > 0) {
            this.setState({
                clients: data.data.data
            });

            this.formRef.current.setFieldsValue({
                client: this.state.client_id,
            });
        }
    }

    onFinish = async (values) => {
        var params = {
            address: values.address,
            latitude: this.state.latitude,
            longitude: this.state.longitude,
            client_id: values.client,
            id: this.state.id
        };

        let data = await addressSave(params);
        if (data.data.success == 1)
            this.props.history.goBack();
    };

    onFinishFailed = (errorInfo) => {
    };

    onClickMap = (position) => {
        this.setState({
            latitude: position.lat,
            longitude: position.lng
        })
    }

    render() {
        return (
            <PageLayout>
                <Breadcrumb style={{margin: '16px 0'}}>
                    <Breadcrumb.Item><Link to="/client-addresses"
                                           className="nav-text">Addresses</Link></Breadcrumb.Item>
                    <Breadcrumb.Item>{this.state.edit ? "Edit" : "Add"}</Breadcrumb.Item>
                </Breadcrumb>
                <PageHeader
                    onBack={() => this.props.history.goBack()}
                    className="site-page-header"
                    title={this.state.edit ? "Addresses Edit" : "Addresses Add"}
                >
                    <Content
                        className="site-layout-background padding-20">
                        <Form
                            ref={this.formRef}
                            name="basic"
                            initialValues={{
                                prefix_mobile: "+1",
                                prefix_phone: "+1",
                                feature_type: "1",
                                delivery_type: "1"
                            }}
                            layout="vertical"
                            onFinish={this.onFinish}
                            onFinishFailed={this.onFinishFailed}
                        >
                            <div className="row">
                                <div className="col-md-6 col-sm-12">
                                    <Form.Item label="Address" name="address"
                                               rules={[{required: true, message: 'Missing client address'}]}
                                               tooltip="Enter client address">
                                        <Input placeholder="Address"/>
                                    </Form.Item>
                                </div>
                                <div className="col-md-6 col-sm-12">
                                    <Form.Item label="Clients" name="client"
                                               rules={[{required: true, message: 'Missing client'}]}
                                               tooltip="Select client">
                                        <Select placeholder="Select client">
                                            {
                                                this.state.clients.map((item) => {
                                                    return (
                                                        <Option value={item.id}
                                                                key={item.id}>{item.name}</Option>);
                                                })
                                            }
                                        </Select>
                                    </Form.Item>
                                </div>
                                <div className="col-md-12 col-sm-12 mb-3" style={{height: '500px'}}>
                                    <label className="defaultLabel">Select client address</label>
                                    <GoogleMapReact
                                        bootstrapURLKeys={{key: "AIzaSyAIZAHqq0Gpw0yNcq6LgsQd9EAGpee5sMg"}}
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
                        </Form>
                    </Content>
                </PageHeader>
            </PageLayout>
        );
    }
}

export default AddressAdd;
