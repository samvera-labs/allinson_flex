import React, { Component, PureComponent } from "react";
import { Button, OverlayTrigger, Tooltip } from "react-bootstrap";
import get from "lodash/get";
import { render } from "react-dom";

//import "bootstrap/dist/css/bootstrap.min.css";

class CollapsibleFieldTemplate extends PureComponent {
  constructor(props) {
    super(props);

    const { formContext } = props;

    const topmostElement = this.isThisTheTopmostElement();

    this.state = {
      collapsed: topmostElement ? false : formContext.hideAll,
      topmostElement,
      hideAll: formContext.hideAll
    };
  }

  static getDerivedStateFromProps(nextProps, state) {
    const { formContext } = nextProps;
    const { hideAll, topmostElement } = state;

    if (hideAll !== formContext.hideAll) {
      return {
        collapsed: topmostElement ? false : formContext.hideAll,
        hideAll: formContext.hideAll
      };
    }

    return null;
  }

  isThisTheTopmostElement = () => {
    const { id } = this.props;

    return id === "root";
  };

  render() {
    const {
      label,
      help,
      required,
      description,
      errors,
      classNames,
      children,
      hidden,
      schema
    } = this.props;

    const { collapsed, hideAll } = this.state;

    const type = get(schema, "type", undefined);

    let legend = null;

    if (type !== "object" && type !== "array") {
      legend = label ? `${label}${required ? "*" : ""}` : null;
    } else if (collapsed) {
      legend = (
        <fieldset className="field field-array field-array-of-object">
          {label ? <legend>{`${label}${required ? "*" : ""}`}</legend> : null}
        </fieldset>
      );
    }

    let contentToRender = null;

    if (!collapsed) {
      contentToRender = (
        <React.Fragment>
          {type !== "object" && type !== "array" ? description : null}
          {children}
          {errors}
          {help}
        </React.Fragment>
      );
    }

    return (
      <React.Fragment>
        {hidden ? null : (
          <div className={classNames}>
            <React.Fragment>
              {!this.isThisTheTopmostElement() ? (
                <OverlayTrigger
                  placement="top"
                  delay={{ show: 300, hide: 100 }}
                  overlay={
                    <Tooltip>
                      {collapsed ? "Expand" : "Collapse"} the field
                      {!collapsed
                        ? `, resetting all of the field's children to being ${
                            hideAll ? "collapsed" : "expanded"
                          }`
                        : ""}
                      .
                    </Tooltip>
                  }
                >
                  <Button
                    variant="outline-secondary"
                    size="sm"
                    style={{
                      display: "inline-block",
                      float: "right",
                      fontSize: "large"
                    }}
                    onClick={() => this.setState({ collapsed: !collapsed })}
                  >
                    {collapsed ? (
                      <React.Fragment>
                        +
                        {get(errors, "props.errors", []).length ? (
                          <span style={{ fontSize: "small" }}>
                            {" "}
                            (Contains errors)
                          </span>
                        ) : null}
                      </React.Fragment>
                    ) : (
                      "-"
                    )}
                  </Button>
                </OverlayTrigger>
              ) : null}
              {legend ? <React.Fragment> {legend}</React.Fragment> : null}
              {contentToRender}
            </React.Fragment>
          </div>
        )}
      </React.Fragment>
    );
  }
}

export default CollapsibleFieldTemplate
