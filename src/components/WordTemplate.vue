<template>
  <div class="word-template">
    <div class="letter-input">
      <span :class="`${lettersClass[0] !== '' ? lettersClass[0] : ''} letter`">{{letters[0] || '&nbsp;'}}</span>
    </div>
    <div class="letter-input">
      <span :class="`${lettersClass[1] !== '' ? lettersClass[1] : ''} letter`">{{letters[1] || '&nbsp;'}}</span>
    </div>
    <div class="letter-input">
      <span :class="`${lettersClass[2] !== '' ? lettersClass[2] : ''} letter`">{{letters[2] || '&nbsp;'}}</span>
    </div>
    <div class="letter-input">
      <span :class="`${lettersClass[3] !== '' ? lettersClass[3] : ''} letter`">{{letters[3] || '&nbsp;'}}</span>
    </div>
    <div class="letter-input">
      <span :class="`${lettersClass[4] !== '' ? lettersClass[4] : ''} letter`">{{letters[4] || '&nbsp;'}}</span>
    </div>
  </div>
</template>

<script>
export default {
  name: 'word-template',
  data() {
    return {
    };
  },
  props: {
    word: String,
    step: Number,
    actualStep: Number,
    letters: Array,
    lettersClass: Array,
  },
}
</script>

<style lang="scss" scoped>
  .letter-input {
    width: 50px;
    height: 50px;
    border: 1px solid;
    font-size: 18px;
    display: inline-block;
    text-transform: uppercase;
  }

  .letter-input:not(:last-child) {
    margin-right: 15px;
  }

  .letter {
    display: flex;
    align-items: center;
    justify-content: center;
    height: 100%;
    width: 100%;
  }

  .rotated {
    transform: rotate3d(1, 0, 0, 360deg);
    transition-duration: 1s;
    background-color: #D7D7D7;
  }

  .semigood {
    background-color: #FF8006 !important;
    color: white;
  }

  .good {
    background-color: #1ACC80 !important;
    color: white;
  }

  .word-template {
    margin-bottom: 15px;
  }
</style>