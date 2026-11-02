# axe-core rules in scope

Source: [axe-core rule descriptions](https://github.com/dequelabs/axe-core/blob/develop/doc/rule-descriptions.md), axe-core 4.x. AAA, experimental, and deprecated rules are out of scope.

## WCAG 2.0 Level A and AA

| Rule | Check | Impact | WCAG |
|---|---|---|---|
| `area-alt` | `<area>` elements of image maps have alternative text | Critical | 2.4.4, 4.1.2 |
| `aria-allowed-attr` | An element's role supports its ARIA attributes | Critical | 4.1.2 |
| `aria-braille-equivalent` | `aria-braillelabel` and `aria-brailleroledescription` have a non-braille equivalent | Serious | 4.1.2 |
| `aria-command-name` | Every ARIA button, link, and menuitem has an accessible name | Serious | 4.1.2 |
| `aria-conditional-attr` | ARIA attributes are used as the role's specification describes | Serious | 4.1.2 |
| `aria-deprecated-role` | Elements do not use deprecated roles | Minor | 4.1.2 |
| `aria-hidden-body` | `aria-hidden="true"` is not on the document body | Critical | 1.3.1, 4.1.2 |
| `aria-hidden-focus` | `aria-hidden` elements are not focusable and contain nothing focusable | Serious | 4.1.2 |
| `aria-input-field-name` | Every ARIA input field has an accessible name | Serious | 4.1.2 |
| `aria-meter-name` | Every ARIA meter has an accessible name | Serious | 1.1.1 |
| `aria-progressbar-name` | Every ARIA progressbar has an accessible name | Serious | 1.1.1 |
| `aria-prohibited-attr` | ARIA attributes are not prohibited for the element's role | Serious | 4.1.2 |
| `aria-required-attr` | Elements with ARIA roles have all required ARIA attributes | Critical | 4.1.2 |
| `aria-required-children` | Roles that require child roles contain them | Critical | 1.3.1 |
| `aria-required-parent` | Roles that require parent roles are contained by them | Critical | 1.3.1 |
| `aria-roles` | Every `role` attribute has a valid value | Critical | 4.1.2 |
| `aria-tab-name` | Every ARIA tab has an accessible name | Serious | 4.1.2 |
| `aria-toggle-field-name` | Every ARIA toggle field has an accessible name | Serious | 4.1.2 |
| `aria-tooltip-name` | Every ARIA tooltip has an accessible name | Serious | 4.1.2 |
| `aria-valid-attr-value` | ARIA attributes have valid values | Critical | 4.1.2 |
| `aria-valid-attr` | Attributes that begin with `aria-` are valid ARIA attributes | Critical | 4.1.2 |
| `blink` | `<blink>` is not used | Serious | 2.2.2 |
| `button-name` | Buttons have discernible text | Critical | 4.1.2 |
| `bypass` | Each page has a way to skip navigation and jump to the content | Serious | 2.4.1 |
| `color-contrast` | Text meets WCAG 2 AA contrast (4.5:1, or 3:1 for large text) | Serious | 1.4.3 |
| `definition-list` | `<dl>` elements are structured correctly | Serious | 1.3.1 |
| `dlitem` | `<dt>` and `<dd>` are contained by a `<dl>` | Serious | 1.3.1 |
| `document-title` | Each document has a non-empty `<title>` | Serious | 2.4.2 |
| `duplicate-id-aria` | Every `id` used in ARIA and labels is unique | Critical | 4.1.2 |
| `form-field-multiple-labels` | A form field does not have multiple label elements | Moderate | 3.3.2 |
| `frame-focusable-content` | Frames with focusable content do not have `tabindex=-1` | Serious | 2.1.1 |
| `frame-title-unique` | Frames have unique `title` attributes | Serious | 4.1.2 |
| `frame-title` | Frames have an accessible name | Serious | 4.1.2 |
| `html-has-lang` | Every document has a `lang` attribute | Serious | 3.1.1 |
| `html-lang-valid` | The `<html>` `lang` attribute has a valid value | Serious | 3.1.1 |
| `html-xml-lang-mismatch` | `lang` and `xml:lang` agree on the base language | Moderate | 3.1.1 |
| `image-alt` | `<img>` has alternative text or a role of none or presentation | Critical | 1.1.1 |
| `input-button-name` | Input buttons have discernible text | Critical | 4.1.2 |
| `input-image-alt` | `<input type="image">` has alternative text | Critical | 1.1.1, 4.1.2 |
| `label` | Every form element has a label | Critical | 4.1.2 |
| `link-in-text-block` | Links in text are distinguishable without relying on color | Serious | 1.4.1 |
| `link-name` | Links have discernible text | Serious | 2.4.4, 4.1.2 |
| `list` | Lists are structured correctly | Serious | 1.3.1 |
| `listitem` | `<li>` elements are used semantically | Serious | 1.3.1 |
| `marquee` | `<marquee>` is not used | Serious | 2.2.2 |
| `meta-refresh` | `<meta http-equiv="refresh">` is not used for a delayed refresh | Critical | 2.2.1 |
| `meta-viewport` | `<meta name="viewport">` does not disable text scaling and zoom | Moderate | 1.4.4 |
| `nested-interactive` | Interactive controls are not nested | Serious | 4.1.2 |
| `no-autoplay-audio` | Media does not autoplay audio for more than 3 seconds without a way to stop or mute it | Moderate | 1.4.2 |
| `object-alt` | `<object>` has alternative text | Serious | 1.1.1 |
| `role-img-alt` | `[role="img"]` elements have alternative text | Serious | 1.1.1 |
| `scrollable-region-focusable` | Scrollable regions are keyboard accessible | Serious | 2.1.1, 2.1.3 |
| `select-name` | `<select>` has an accessible name | Critical | 4.1.2 |
| `summary-name` | `<summary>` has discernible text | Serious | 4.1.2 |
| `svg-img-alt` | `<svg>` with an img or graphics role has accessible text | Serious | 1.1.1 |
| `td-headers-attr` | Cells using `headers` refer only to `<th>` in the same table | Serious | 1.3.1 |
| `th-has-data-cells` | `<th>`, columnheader, and rowheader elements have data cells they describe | Serious | 1.3.1 |
| `valid-lang` | `lang` attributes have valid values | Serious | 3.1.2 |
| `video-caption` | `<video>` has captions | Critical | 1.2.2 |

## WCAG 2.1 Level A and AA

| Rule | Check | Impact | WCAG |
|---|---|---|---|
| `autocomplete-valid` | The `autocomplete` attribute is correct and suitable for the field | Serious | 1.3.5 |
| `avoid-inline-spacing` | Text spacing set in `style` attributes can be overridden by user stylesheets | Serious | 1.4.12 |
| `label-content-name-mismatch` | An element labelled by its content includes its visible text in its accessible name | Serious | 2.5.3 |

## WCAG 2.2 Level A and AA

| Rule | Check | Impact | WCAG |
|---|---|---|---|
| `target-size` | Touch targets are at least 24px or have enough space around them | Serious | 2.5.8 |

## Best practices

| Rule | Check | Impact |
|---|---|---|
| `accesskeys` | Every `accesskey` value is unique | Serious |
| `aria-allowed-role` | The `role` value is appropriate for the element | Minor |
| `aria-dialog-name` | Every dialog and alertdialog has an accessible name | Serious |
| `aria-text` | `role="text"` is only on elements with no focusable descendants | Serious |
| `aria-treeitem-name` | Every treeitem has an accessible name | Serious |
| `empty-heading` | Headings have discernible text | Minor |
| `empty-table-header` | Table headers have discernible text | Minor |
| `frame-tested` | Frames contain the axe-core script | Critical |
| `heading-order` | Heading levels are in a semantically correct order | Moderate |
| `image-redundant-alt` | Image alternative text is not repeated as nearby text | Minor |
| `label-title-only` | Form elements have a visible label, not only a hidden label, `title`, or `aria-describedby` | Serious |
| `landmark-banner-is-top-level` | The banner landmark is at top level | Moderate |
| `landmark-contentinfo-is-top-level` | The contentinfo landmark is at top level | Moderate |
| `landmark-main-is-top-level` | The main landmark is at top level | Moderate |
| `landmark-no-duplicate-banner` | At most one banner landmark | Moderate |
| `landmark-no-duplicate-contentinfo` | At most one contentinfo landmark | Moderate |
| `landmark-no-duplicate-main` | At most one main landmark | Moderate |
| `landmark-one-main` | The document has a main landmark | Moderate |
| `landmark-unique` | Landmarks are unique | Moderate |
| `page-has-heading-one` | The page has a level-one heading | Moderate |
| `region` | All page content is inside landmarks | Moderate |
| `scope-attr-valid` | The `scope` attribute is used correctly on tables | Moderate |
| `skip-link` | Skip links have a focusable target | Moderate |
| `tabindex` | `tabindex` values are not greater than 0 | Serious |
| `table-duplicate-name` | `<caption>` text differs from the `summary` attribute | Minor |
