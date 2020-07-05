import React, { Component } from "react"
import { Nav, NavItem } from 'react-bootstrap';

import { css } from "@emotion/core";
import RotateLoader from "react-spinners/RotateLoader";
import PropertySelector from './property_selector'

// This React warning (each child in a list should have unique key prop) doesnt apply
// to our use case. However, React's dev team is very insistant about not providing a
// sane way to turn off this warning. So here we are.
/* console.error = (() => {
 *   const _error = console.error
 *   const re = /^Warning: Each child in a list should have a unique "key" prop/
 *   return (...args) => {
 *     const line = args[0]
 *     if (re.test(line)) {
 *       // Ignore key warnings
 *     } else {
 *       _error(...args)
 *     }
 *   }
 * })() */

const override = css`
  display: block;
  position: fixed;
  top: 50%;
  left: 60%;
  margin-top: -50px;
  margin-left: -100px;
`;

class FlexibleMetadata extends Component {
  constructor(props) {
    super(props)
    this.state = {
      isLoading: true,
      tab: 'profile'
    }
    this.setLoading = this.setLoading.bind(this)
  }

  loadSpinner = () => {
    return(
      <div className="sweet-loading">
        <RotateLoader
          css={override}
          size={35}
          margin={20}
          color={"#4A90E2"}
          loading={this.state.isLoading}
        />
      </div>
    );
  }

  setLoading = (loading) => {
    this.setState({ isLoading: loading })
  }

  handleSelect(eventKey, event) {
    event.preventDefault()
    this.setState({tab: eventKey})
  }

  render() {
    const { schema, flexible_metadata_profile } = this.props
    const { tab, selectedProperty } = this.state
    return (
      <div>
        <Nav bsStyle="tabs" activeKey={tab} onSelect={this.handleSelect.bind(this)}>
          <NavItem eventKey="m3_version" title='M3 Version' href="#m3_version">
            {schema.properties.m3_version.title}
          </NavItem>
          <NavItem eventKey="profile" title='Profile' href="#profile">
            {schema.properties.profile.title}
          </NavItem>
          <NavItem eventKey="classes" title="Classes" href="#classes">
            {schema.properties.classes.title}
          </NavItem>
          <NavItem eventKey="contexts" title='Contexts' href="#contexts">
            {schema.properties.contexts.title}
          </NavItem>
          <NavItem eventKey="properties" title='Properties' href="#properties">
            {schema.properties.properties.title}
          </NavItem>
          <NavItem eventKey="mappings" title='Mappings' href="#mappings">
            {schema.properties.mappings.title}
          </NavItem>
        </Nav>

        <div className='panel-body'>
          { this.loadSpinner() }
          <PropertySelector schema={schema} tab={tab} flexible_metadata_profile={flexible_metadata_profile} setLoading={this.setLoading} ></PropertySelector>
        </div>
      </div>
    )
  }
}

export default FlexibleMetadata
