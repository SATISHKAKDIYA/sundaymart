import React, {useContext} from 'react';
import {Layout, Menu, Dropdown, Avatar, Button} from 'antd';
import {FiBell} from 'react-icons/fi';
import {LogoutOutlined} from "@ant-design/icons";
import {AuthContext} from "../helpers/AuthProvider";

const {Header} = Layout;

const HeaderMenu = (props) => {
    const {signin} = useContext(AuthContext);

    let logout = () => {
        signin(false);
    }

    const menu = (
        <Menu>
            <Menu.Item key="0">
                <a href="https://www.antgroup.com">1st menu item</a>
            </Menu.Item>
            <Menu.Item key="1">
                <a href="https://www.aliyun.com">2nd menu item</a>
            </Menu.Item>
            <Menu.Divider/>
            <Menu.Item key="3">3rd menu item</Menu.Item>
        </Menu>
    );

    const user_menu = (
        <Menu>
            <Menu.Item key="4" icon={<LogoutOutlined />} onClick={() => logout()}>Logout</Menu.Item>
        </Menu>
    );

    return (<Header className="site-layout-background" style={{padding: 0}}>
        <div id="g-header" className="g-header-right float-right">
            <ul className="nav">
                <li className="nav-item">
                    <Dropdown overlay={menu} trigger={['click']}>
                        <Button shape="circle"><FiBell size={16}/></Button>
                    </Dropdown>
                </li>
                <li className="nav-item">
                    <Dropdown overlay={user_menu} trigger={['click']}>
                        <Avatar src="https://zos.alipayobjects.com/rmsportal/ODTLcjxAfvqbxHnVXCYX.png"/>
                    </Dropdown>
                </li>
            </ul>
        </div>
    </Header>);
}

export default HeaderMenu;

