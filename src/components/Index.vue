<template>
  <div class="index-container">
    <div class="words-container">
      <word-template v-for="(step, key) in lettersByStep" :actualStep="actualStep" :step="key + 1" :letters="lettersByStep[key]" :lettersClass="lettersClassByStep[key]"></word-template>
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
      actualStep: 0,
      lettersByStep: [],
      lettersClassByStep: [],
      lettersList: ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'],
      hasWin: false,
      showResult: false,
      nbLetters: 5,
      nbSteps: 6,
    };
  },
  methods: {
    validWord() {
      const goodLetters = this.word.split('');
      let nbGoods = 0;
      for (let i = 0; i < this.lettersByStep[this.actualStep].length; i++) {
        if (this.lettersByStep[this.actualStep][i] === goodLetters[i]) {
          // Bon lettre au bon emplacement
          nbGoods++;
          this.lettersClassByStep[this.actualStep][i] = 'good rotated';
        } else if (goodLetters.indexOf(this.lettersByStep[this.actualStep][i]) !== -1) {
          // Bonne lette, mauvais emplacement
          if (this.lettersByStep[this.actualStep][goodLetters.indexOf(this.lettersByStep[this.actualStep][i])] !== this.lettersByStep[this.actualStep][i]) {
            this.lettersClassByStep[this.actualStep][i] = 'semigood rotated';
          } else if (this.nbOccurences(this.lettersByStep[this.actualStep][i]) > 1) {
            // Si on a plusieurs occurences de la meme lettre, on met en semi good le nombre d'occurences correspondant
            let alreadyPut = 0;
            for (let j = 0; j < i; j++) {
              if (this.lettersByStep[this.actualStep][j] === this.lettersByStep[this.actualStep][i]) {
                alreadyPut++;
              }
            }
            if (this.nbOccurences(this.lettersByStep[this.actualStep][i]) > alreadyPut) {
              this.lettersClassByStep[this.actualStep][i] = 'semigood rotated';
            } else {
              this.lettersClassByStep[this.actualStep][i] = 'rotated';
            }
          } else {
            this.lettersClassByStep[this.actualStep][i] = 'rotated';
          }
        } else {
          this.lettersClassByStep[this.actualStep][i] = 'rotated';
        }
      }
      this.actualStep++;
      if (nbGoods === this.nbLetters) {
        this.hasWin = true;
        this.showResult = true;
      } else if (this.actualStep === (this.nbSteps + 1)) {
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
    for (let i = 0; i < this.nbSteps; i++) {
      this.lettersByStep.push([]);
      this.lettersClassByStep.push([]);
      for (let j = 0; j < this.nbLetters; j++) {
        this.lettersClassByStep[i].push('');
      }
    }
    axios.get('/static/word-list.json').then((result) => {
      const wordsList = result.data;
      const wordNumber = Math.floor(Math.random() * wordsList.length);
      this.word = wordsList[wordNumber];
    });
    document.addEventListener('keyup', (e) => {
      if (!this.hasWin) {
        if (e.key === 'Enter' && this.lettersByStep[this.actualStep].length === this.nbLetters) {
          this.validWord();
        } else if (e.key === 'Backspace') {
          this.lettersByStep[this.actualStep].pop();
        } else if (this.lettersByStep[this.actualStep].length < this.nbLetters && this.lettersList.indexOf(e.key) !== -1) {
          this.lettersByStep[this.actualStep].push(e.key);
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
  text-align: center;
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
