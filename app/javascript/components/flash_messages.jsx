import React from "react"
import PropTypes from "prop-types"
import {
  TransitionGroup,
} from 'react-transition-group';
import update from 'immutability-helper';
import Alert from "./alert"

class FlashMessages extends React.Component {
  constructor(props) {
    super(props);
    this.state = { messages: props.messages };

    window.flash_messages = this;
  }

  addMessage(message) {
    const messages = update(this.state.messages, { $push: [message] });
    this.setState({ messages: messages });
  }

  removeMessage(message) {
    const index = this.state.messages.indexOf(message);
    const messages = update(this.state.messages, { $splice: [[index, 1]] });
    this.setState({ messages: messages });
  }

  render () {
    const alerts = this.state.messages.map( message =>
      <Alert key={ message.id } message={ message }
        onClose={ () => this.removeMessage(message) } />
    );

    return(
      <TransitionGroup>
        { alerts }
      </TransitionGroup>
    );
  }
}

FlashMessages.propTypes = {
  messages: PropTypes.array.isRequired
};

export default FlashMessages
