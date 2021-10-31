import React from 'react';
import {Breadcrumb, Button, Layout, Table, Space, PageHeader, Image, Checkbox, Tag, Popconfirm} from "antd";

import reqwest from 'reqwest';
import {CheckCircleOutlined, CloseCircleOutlined} from "@ant-design/icons";
import extrasDelete from "../../../requests/Extras/ExtrasDelete";

class Extras extends React.Component {
    columns = [
        {
            title: 'Extra group name',
            dataIndex: 'group',
        },
        {
            title: 'Name',
            dataIndex: 'name',
        },
        {
            title: 'Description',
            dataIndex: 'description',
        },
        {
            title: 'Active',
            dataIndex: 'active',
            render: (active) => {
                if (active == 1)
                    return (<Tag icon={<CheckCircleOutlined/>} color="success">
                        Active
                    </Tag>);
                else
                    return (<Tag icon={<CloseCircleOutlined/>} color="error">
                        Inactive
                    </Tag>);
            },
        },
        {
            title: 'Options',
            dataIndex: 'options',
            render: (options, row) => {
                return (<div>
                    {
                        options.edit && (
                            <Button type="link" onClick={() => this.props.onEdit(row.id)}>Edit
                            </Button>
                        )
                    }
                    {
                        options.delete && row.default != 1 && (<Popconfirm
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

    constructor(props) {
        super(props);

        this.state = {
            data: [],
            pagination: {
                current: 1,
                pageSize: 10,
            },
            loading: false,
            visibleConfirm: false,
            confirmLoading: false,
            product_id: props.product_id
        };
    }

    componentDidMount() {
        const {pagination} = this.state;
        this.fetch({pagination});
    }

    handleOk = async (id) => {
        this.setState({
            confirmLoading: true
        });

        let data = await extrasDelete(id);

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
            url: '/api/auth/extra/datatable',
            method: 'post',
            type: 'json',
            headers: {
                "Authorization": "Bearer " + token
            },
            data: {
                product_id: this.state.product_id,
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
            <PageHeader
                className="site-page-header"
                title="Product extras"
                extra={[
                    <Button type="primary" key="add"
                            onClick={() => this.props.onEdit(0)}
                            className="btn-success">
                        Add product extras
                    </Button>
                ]}
            >
                <Table
                    columns={this.columns}
                    rowKey={record => record.id}
                    dataSource={data}
                    pagination={pagination}
                    loading={loading}
                    onChange={this.handleTableChange}
                />
            </PageHeader>
        );
    }
}

export default Extras;
