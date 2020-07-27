import React, { Component } from "react";
import AllinsonFlexProfileForm from './allinson_flex_profile_form'

const uiSchema =  {
  "properties": {
    "ui:options":  {
      "addable": false,
      "removable": false
    }
  }
}

class PropertySelector extends Component {

  constructor(props) {
    super(props)
    this.state = {
      tab: this.props.tab,
      allinson_flex_profile: this.props.allinson_flex_profile,
      selectedProperty: false
    }
  }

  static getDerivedStateFromProps(nextProps, prevState) {
    if (prevState.tab !== nextProps.tab) {
      return {
        selectedProperty: false,
        tab: nextProps.tab
      }
    }
    return null
  }

  collectProperties(tab) {
    const output = []
    for (const property in this.props.allinson_flex_profile.profile[`${tab}`]) {
      output.push(
        <div className="btn-group col-sm-4" role="group" key={property}>
          <a className='btn btn-info col-sm-11' style={{marginBottom: '15px'}}  onClick={this.handlePropertySelect.bind(this)} href='#'>{property}</a>
          <button className='btn btn-info btn-danger col-sm-1' style={{marginBottom: '15px'}}  onClick={() => this.removeProperty(property)} href='#'>
            <i className="glyphicon glyphicon-remove"></i>
          </button>
        </div>
      )
    }
    return output
  }

  handlePropertySelect(event) {
    event.preventDefault()
    this.setState({selectedProperty: event.target.text})
  }

  handlePropertyClear(event) {
    event.preventDefault()
    this.setState({selectedProperty: false})
  }

  addProperty = (tab) => {
    if(this.props.allinson_flex_profile.profile[tab] == undefined){
      this.props.allinson_flex_profile.profile[tab] = {}
    }

    const newFormData = { newKey: {} }
    this.setState({selectedProperty: 'newKey'})
  }

  removeProperty = (property) => {
    const response = confirm("Are you sure you want to delete property: '" + property +  "'?");
    if(response == true){
      delete this.props.allinson_flex_profile.profile[this.props.tab][property]
      const updateProfile = this.props.allinson_flex_profile.profile[this.props.tab]
      this.setState({allinson_flex_profile: updateProfile})
    } else { 
      return
    }
  }

  pickRender() {
    const { schema,
            tab,
            allinson_flex_profile,
            setLoading
    } = this.props
    const { selectedProperty } = this.state
    const tabsWithPropertyBtns = ['classes', 'contexts', 'mappings', 'properties']

    if(tabsWithPropertyBtns.includes(tab) && !selectedProperty) {
      return (
        <div className='row'>
          <div className='col-sm-12'>
            <h3 className="col-sm-11">Select a Property Or Add New</h3>
            <button type="button" className="btn btn-info btn-add col-sm-1" tabIndex="0" style={{margin: '20px 0px 10px'}} onClick={() => this.addProperty(tab)}><i className="glyphicon glyphicon-plus"></i></button>
          </div>
          { this.collectProperties(tab) }
        </div>
      )
    } else if(tabsWithPropertyBtns.includes(tab)) {
      return (
        <React.Fragment>
          <a id='back-arrow' className="btn btn-info" style={{marginBottom: '15px'}} onClick={this.handlePropertyClear.bind(this)}><span className='glyphicon glyphicon-menu-left' aria-hidden="true"></span>Back</a>
          <AllinsonFlexProfileForm schema={schema} tab={tab} selectedProperty={selectedProperty} allinson_flex_profile={allinson_flex_profile} uiSchema={uiSchema} setLoading={setLoading} ></AllinsonFlexProfileForm>
        </React.Fragment>
      )
    } else {
      return (
        <AllinsonFlexProfileForm schema={schema} tab={tab} allinson_flex_profile={allinson_flex_profile} setLoading={setLoading} ></AllinsonFlexProfileForm>
      )
    }

  }
  render() {
    return (
      <div>
        { this.pickRender() }
      </div>
    )
  }
}

export default PropertySelector
