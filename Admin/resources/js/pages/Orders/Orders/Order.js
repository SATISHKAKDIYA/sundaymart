import React from 'react';
import PageLayout from "../../../layouts/PageLayout";
import {Breadcrumb, Button, Layout, Table, Space, PageHeader, Image, Checkbox, Tag, Popconfirm} from "antd";
import {Link} from 'react-router-dom';

const {Content} = Layout;
import reqwest from 'reqwest';
import orderDelete from "../../../requests/Orders/OrderDelete";
import {isAllowed} from "../../../helpers/IsAllowed";

class Order extends React.Component {
    columns = [
        {
            title: 'ID',
            dataIndex: 'id',
        },
        {
            title: 'Name',
            dataIndex: 'user',
        },
        {
            title: 'Shop',
            dataIndex: 'shop',
        },
        {
            title: 'Amount',
            dataIndex: 'amount',
        },
        {
            title: 'Order status',
            dataIndex: 'order_status',
            render: (order_status, row) => {
                var order_status_colors = [
                    "default",
                    "processing",
                    "warning",
                    "success",
                    "error"
                ];
                return (<Tag color={order_status_colors[row.order_status_id - 1]}>{order_status}</Tag>);
            }
        },
        {
            title: 'Payment status',
            dataIndex: 'payment_status',
            render: (payment_status, row) => {
                var payment_status_colors = [
                    "success",
                    "error"
                ];
                return (<Tag color={payment_status_colors[row.payment_status_id - 1]}>{payment_status}</Tag>);
            }
        },
        {
            title: 'Payment methods',
            dataIndex: 'payment_method',
            render: (payment_method, row) => {
                var payment_method_colors = [
                    "success",
                    "processing",
                    "warning",
                ];
                return (<Tag color={payment_method_colors[row.payment_method_id - 1]}>{payment_method}</Tag>);
            }
        },
        {
            title: 'Order date',
            dataIndex: 'order_date',
        },
        {
            title: 'Delivery date',
            dataIndex: 'delivery_date',
        },
        {
            title: 'Options',
            dataIndex: 'options',
            render: (options, row) => {
                return (<div>
                    {
                        options.edit && isAllowed("/orders/edit") && (
                            <Button type="link">
                                <Link to={{
                                    pathname: "/orders/edit",
                                    state: {id: row.id, edit: true}
                                }} className="nav-text">Edit</Link>
                            </Button>
                        )
                    }
                    {
                        options.delete && isAllowed("/orders/delete") && row.default != 1 && (<Popconfirm
                            title="Do you want to delete ?"
                            visible={this.state.visible}
                            onConfirm={() => this.handleOk(row.id)}
                            okButtonProps={{loading: this.state.confirmLoading}}
                            onCancel={this.handleCancel}
                        >
                            <Button type="link" className="text-danger" onClick={this.showPopconfirm}>
                                Delete
                            </Button>
                        </Popconfirm>)
                    }
                </div>);
            },
        },
    ];

    state = {
        data: [],
        pagination: {
            current: 1,
            pageSize: 10,
        },
        loading: false,
        visibleConfirm: false,
        confirmLoading: false
    };

    componentDidMount() {
        const {pagination} = this.state;
        this.fetch({pagination});
    }

    handleOk = async (id) => {
        this.setState({
            confirmLoading: true
        });

        let data = await orderDelete(id);

        if (data.data.success == 1) {
            this.setState({
                confirmLoading: false,
                visibleConfirm: false
            });
        }

        const {pagination} = this.state;
        this.fetch({pagination});
    };

    handleCancel = () => {
        this.setState({
            visibleConfirm: false
        })
    };

    showPopconfirm = () => {
        this.setState({
            visibleConfirm: true
        })
    };

    handleTableChange = (pagination, filters, sorter) => {
        this.fetch({
            sortField: sorter.field,
            sortOrder: sorter.order,
            pagination,
            ...filters,
        });

        this.setState({pagination});
    };

    fetch = (params = {}) => {
        const token = localStorage.getItem('jwt_token');
        this.setState({loading: true});
        reqwest({
            url: '/api/auth/order/datatable',
            method: 'post',
            type: 'json',
            headers: {
                "Authorization": "Bearer " + token
            },
            data: {
                length: params.pagination.pageSize,
                start: (params.pagination.current - 1) * params.pagination.pageSize,
            },
        }).then(data => {
            this.setState({
                loading: false,
                data: data.data,
                pagination: {
                    current: params.pagination.current,
                    pageSize: 10,
                    total: data.total,
                },
            });
        });
    };

    render() {
        const {data, pagination, loading} = this.state;

        return (
            <PageLayout>
                <Breadcrumb style={{margin: '16px 0'}}>
                    <Breadcrumb.Item>Orders</Breadcrumb.Item>
                </Breadcrumb>
                <PageHeader
                    className="site-page-header"
                    title="Orders"
                    subTitle="Create, remove and edit orders"
                    extra={isAllowed("/orders/add") && [
                        <Link to="/orders/add" key="add_order" className="btn btn-success">
                            Add order
                        </Link>
                    ]}
                >
                    <Content
                        className="site-layout-background">
                        <Table
                            columns={this.columns}
                            rowKey={record => record.id}
                            dataSource={data}
                            pagination={pagination}
                            loading={loading}
                            onChange={this.handleTableChange}
                        />
                    </Content>
                </PageHeader>
            </PageLayout>
        );
    }
}

export default Order;
