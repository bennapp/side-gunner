import React from 'react';
import abilityData from './abilityData.js'
import './styles.css'

export default function SideGunner() {
  function renderSynergy(synergy) {
    const name = synergy['name'];

    return (
      <div className={'synergy-pane'}>
        <img title={`${name}:${synergy['win_rate']}`} className={'ability-img-sml'} src={ abilityData[name]['link'] }/>
      </div>
    );
  }

  function renderSynergies(ability) {
    return (
      <div className={'synergy-list'}>{ ability['synergies'].map((synergy) => renderSynergy(synergy)) }</div>
    );
  }

  function renderAbility(ability) {
    return (
      <div className={'ability-pane'}>
        <span>{ ability['name'] }</span>
        <img className={'ability-img-lrg'} src={ ability['link'] }/>
        <span>{ ability['win_rate'] }</span>

        { renderSynergies(ability) }
      </div>
    )
  };

  function renderAbilities() {
    return (
      <div className={'ability-list'}>
        {
          Object.keys(abilityData).map((abilityKey) => {
            return renderAbility(abilityData[abilityKey]);
          })
        }
      </div>
    )
  };

  return (
    <div className={'page'}>
      { renderAbilities() }
    </div>
  );
}
