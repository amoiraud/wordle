<template>
  <div class="index-container">
    <div class="words-container">
      <word-template :actualStep="actualStep" :step="1" :letters="lettersByStep[0]" :lettersClass="lettersClassByStep[0]"></word-template>
      <word-template :actualStep="actualStep" :step="2" :letters="lettersByStep[1]" :lettersClass="lettersClassByStep[1]"></word-template>
      <word-template :actualStep="actualStep" :step="3" :letters="lettersByStep[2]" :lettersClass="lettersClassByStep[2]"></word-template>
      <word-template :actualStep="actualStep" :step="4" :letters="lettersByStep[3]" :lettersClass="lettersClassByStep[3]"></word-template>
      <word-template :actualStep="actualStep" :step="5" :letters="lettersByStep[4]" :lettersClass="lettersClassByStep[4]"></word-template>
      <word-template :actualStep="actualStep" :step="6" :letters="lettersByStep[5]" :lettersClass="lettersClassByStep[5]"></word-template>
    </div>
    <div class="result-container" v-if="showResult">
      <span v-if="hasWin" class="win">
        BRAVO !!
      </span>
      <span v-else class="lose">
        Dommage, le mot était <strong>{{word}}</strong>
      </span>
      <br/><br/>
      <v-btn class="btn-new-game" @click="reload()">Nouvelle partie</v-btn>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import WordTemplate from './WordTemplate.vue';

export default {
  name: 'index-wordle',
  components: {
    WordTemplate,
  },
  data() {
    return {
      rotated: false,
      word: '',
      actualStep: 1,
      lettersByStep: [[],[],[],[],[],[]],
      lettersClassByStep: [
        ['', '', '', '', ''],
        ['', '', '', '', ''],
        ['', '', '', '', ''],
        ['', '', '', '', ''],
        ['', '', '', '', ''],
        ['', '', '', '', ''],
      ],
      lettersList: ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'],
      hasWin: false,
      showResult: false,
    };
  },
  methods: {
    validWord() {
      const goodLetters = this.word.split('');
      let nbGoods = 0;
      for (let i = 0; i < this.lettersByStep[this.actualStep - 1].length; i++) {
        if (this.lettersByStep[this.actualStep - 1][i] === goodLetters[i]) {
          // Bon lettre au bon emplacement
          nbGoods++;
          this.lettersClassByStep[this.actualStep - 1][i] = 'good rotated';
        } else if (goodLetters.indexOf(this.lettersByStep[this.actualStep - 1][i]) !== -1) {
          // Bonne lette, mauvais emplacement
          if (this.lettersByStep[this.actualStep - 1][goodLetters.indexOf(this.lettersByStep[this.actualStep - 1][i])] !== this.lettersByStep[this.actualStep - 1][i]) {
            this.lettersClassByStep[this.actualStep - 1][i] = 'semigood rotated';
          } else if (this.nbOccurences(this.lettersByStep[this.actualStep - 1][i]) > 1) {
            // Si on a plusieurs occurences de la meme lettre, on met en semi good le nombre d'occurences correspondant
            let alreadyPut = 0;
            for (let j = 0; j < i; j++) {
              if (this.lettersByStep[this.actualStep - 1][j] === this.lettersByStep[this.actualStep - 1][i]) {
                alreadyPut++;
              }
            }
            if (this.nbOccurences(this.lettersByStep[this.actualStep - 1][i]) > alreadyPut) {
              this.lettersClassByStep[this.actualStep - 1][i] = 'semigood rotated';
            } else {
              this.lettersClassByStep[this.actualStep - 1][i] = 'rotated';
            }
          } else {
            this.lettersClassByStep[this.actualStep - 1][i] = 'rotated';
          }
        } else {
          this.lettersClassByStep[this.actualStep - 1][i] = 'rotated';
        }
      }
      this.actualStep++;
      if (nbGoods === 5) {
        this.hasWin = true;
        this.showResult = true;
      } else if (this.actualStep === 7) {
        this.showResult = true;
      }
    },
    // Nombre d'occurence de la lettre dans la réponse
    nbOccurences(letter) {
      const goodLetters = this.word.split('');
      let occ = 0;
      for (let i = 0; i < goodLetters.length; i++) {
        if (goodLetters[i] === letter) {
          occ++;
        }
      }
      return occ;
    },
    reload() {
      this.$router.go();
    },
  },
  created() {
    axios.get('/static/word-list.json').then((result) => {
      const wordsList = result.data;
      const wordNumber = Math.floor(Math.random() * wordsList.length);
      this.word = wordsList[wordNumber];
    });
    document.addEventListener('keyup', (e) => {
      if (!this.hasWin) {
        if (e.key === 'Enter' && this.lettersByStep[this.actualStep - 1].length === 5) {
          this.validWord();
        } else if (e.key === 'Backspace') {
          this.lettersByStep[this.actualStep - 1].pop();
        } else if (this.lettersByStep[this.actualStep - 1].length < 5 && this.lettersList.indexOf(e.key) !== -1) {
          this.lettersByStep[this.actualStep - 1].push(e.key);
        }
      }
    });
  },
}
</script>

<style lang="scss" scoped>
.index-container {
  padding-top: 50px;
  background-color: white;
  height: calc(100vh - 70px - 40px);
  overflow-y: scroll;
}

.words-container {
  width: 315px;
  margin-left: auto;
  margin-right: auto;
}

.result-container {
  font-size: 20px;
  font-weight: bold;
  margin-top: 30px;
  text-align: center;

  .win {
    font-weight: bold;
    color: #1ACC80;
  }

  .lose {
    color: red;

    strong {
      color: black;
    }
  }
}

.btn-new-game {
  background-color: #041D3D;
  color: white;
  font-weight: 700;
  padding: 8px 15px;
  border-radius: 5px;
  cursor: pointer;
}
</style>
