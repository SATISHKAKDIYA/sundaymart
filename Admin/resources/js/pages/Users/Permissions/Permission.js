import React from 'react';
import PageLayout from "../../../layouts/PageLayout";
import {Breadcrumb, Button, Layout, Table, Space, PageHeader, Image, Checkbox, Tag, Popconfirm, message} from "antd";
import {Link} from 'react-router-dom';

const {Content} = Layout;
import reqwest from 'reqwest';
import {CheckCircleOutlined, CloseCircleOutlined, AndroidOutlined, AppleOutlined} from "@ant-design/icons";
import clientDelete from "../../../requests/Clients/ClientDelete";
import roleActive from "../../../requests/RoleActive";
import rolePermissionSave from "../../../requests/Permissions/RolePermissionSave";

const {CheckableTag} = Tag;


class Permission extends React.Component {
    state = {
        data: [],
        pagination: {
            current: 1,
            pageSize: 10,
        },
        loading: false,
        visibleConfirm: false,
        confirmLoading: false,
        columns: [
            {
                title: 'Name',
                dataIndex: 'name',
            }
        ]
    };

    constructor(props) {
        super(props);

        this.handleChange = this.handleChange.bind(this);

        this.getActiveRoles();
    }

    componentDidMount() {
        const {pagination} = this.state;
        this.fetch({pagination});
    }

    getActiveRoles = async () => {
        let data = await roleActive();
        if (data.data.success == 1 && data.data.data.length > 0) {
            for (let i = 0; i < data.data.data.length; i++) {
                var columnsData = this.state.columns;
                let name = data.data.data[i].name;
                columnsData.push({
                    title: name,
                    dataIndex: name,
                    render: (value, row) => {
                        return (<CheckableTag
                            key={row.id + "" + value}
                            checked={value == 1}
                            onChange={checked => this.handleChange(row.id, name, checked)}
                        >
                            {
                                value == 1 ? "Enabled" : "Disabled"
                            }
                        </CheckableTag>);
                    }
                });
            }

            this.setState({
                columns: columnsData
            });
        }
    }

    handleChange = async (id, name, checked) => {
        if (name == "Superadmin" || name == "Delivery boy") {
            message.error('Cannot change permissions of Superadmin and Delivery boy');
            return false;
        }

        var data = await rolePermissionSave(id, name, checked ? 1 : 0);

        if (data.data.success == 1) {
            const {pagination} = this.state;
            this.fetch({pagination});
        }
    }

    handleOk = async (id) => {
        this.setState({
            confirmLoading: true
        });

        let data = await clientDelete(id);

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

        this.setState({
            pagination
        });
    };

    fetch = (params = {}) => {
        const token = localStorage.getItem('jwt_token');
        this.setState({loading: true});
        reqwest({
            url: '/api/auth/permission/datatable',
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
                    <Breadcrumb.Item>Permissions</Breadcrumb.Item>
                </Breadcrumb>
                <PageHeader
                    className="site-page-header"
                    title="Permissions"
                >
                    <Content
                        className="site-layout-background">
                        {
                            this.state.columns.length > 1 && (
                                <Table
                                    columns={this.state.columns}
                                    rowKey={record => record.id}
                                    dataSource={data}
                                    pagination={pagination}
                                    loading={loading}
                                    onChange={this.handleTableChange}
                                />
                            )
                        }
                    </Content>
                </PageHeader>
            </PageLayout>
        );
    }
}

export default Permission;
