---
name: frontend-a11y
description: Audit storybook components in this code repo against the axe-core rule set (WCAG 2.0, 2.1, and 2.2 level A and AA, plus best practices), by reading the component code and checking the affected stories in Storybook Accessibility panel. Self-review mode fixes findings; report mode lists them.
---

# Frontend accessibility

Check every component against the axe-core rules below, then confirm the result in Storybook's Accessibility panel. The panel runs axe-core; it comes from `@storybook/addon-a11y`, which `site/.storybook/main.ts` already loads.

The rules come from [axe-core's rule descriptions](https://github.com/dequelabs/axe-core/blob/develop/doc/rule-descriptions.md) (axe-core 4.xx). The repo's installed axe-core may be older, so a rule missing from the panel is not a pass. Check it in the code; ensure dependency versions match.

## Modes

- **Self-review** (your own branch): fix every `blocking` and `should-fix` finding with the smallest change, then re-run this audit.
- **Report** (someone else's PR): list findings only. Change nothing.

## Workflow

1. Identify the relevant changed `.tsx` files and the stories that render them.
2. **Code audit.** For each changed component, check the rules in the tables below that apply to the elements it renders. Read the shared primitive a component wraps (`site/src/components/`) when the diff alone cannot answer a check, for example whether `Button` already forwards `aria-label`.
3. **Story audit.** Run `npm storybook` in the storybook ui directory, then open each affected story in a browser, using a `computer_use` subagent or `agent-browser`. Then:
   1. Open the **Accessibility** tab, and record each violation and incomplete item: rule ID, impact, and target.
   2. Repeat in the states the change affects: keyboard focus, open menus or dialogs, hover content, dark and light themes, and a 320px width for reflow.
   3. Check the same stories on `<base>`. A violation on both is pre-existing. A violation only on the branch is introduced.
   4. If no story covers a changed state, report that as a finding.
4. Ignore these page-level rules in isolated stories: `document-title`, `html-has-lang`, `html-lang-valid`, `bypass`, `landmark-one-main`, `page-has-heading-one`, `region`, `frame-tested`. Check them only when the ui touches page shells, layouts, or `index.html`.
5. Report the results (Output). In self-review mode, fix and repeat from step 2 until no `blocking` or `should-fix` finding remains.
6. Stop Storybook.

## Severity

| axe impact | Introduced by the diff | Pre-existing in touched code |
|---|---|---|
| Critical, Serious | `blocking` | `should-fix` if the diff edits that element, otherwise a note |
| Moderate | `should-fix` | note |
| Minor | `nit` | note |

- Best-practice rules rank one level lower than this table.
- An "incomplete" (needs review) result is a finding only after you verify it by hand. One example is `color-contrast` over a gradient or image.
- Notes are not findings. List them so a reviewer can file follow-up tickets.

## Rules

### WCAG 2.0 Level A and AA

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

### WCAG 2.1 Level A and AA

| Rule | Check | Impact | WCAG |
|---|---|---|---|
| `autocomplete-valid` | The `autocomplete` attribute is correct and suitable for the field | Serious | 1.3.5 |
| `avoid-inline-spacing` | Text spacing set in `style` attributes can be overridden by user stylesheets | Serious | 1.4.12 |
| `label-content-name-mismatch` | An element labelled by its content includes its visible text in its accessible name | Serious | 2.5.3 |

### WCAG 2.2 Level A and AA

| Rule | Check | Impact | WCAG |
|---|---|---|---|
| `target-size` | Touch targets are at least 24px or have enough space around them | Serious | 2.5.8 |

### Best practices

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

AAA, experimental, and deprecated axe rules are out of scope.

## What axe cannot check

Automated rules cover only part of WCAG. Check these by hand in the story whenever the diff touches the behavior:

- Keyboard: every control is reachable with Tab, and operable with Enter, Space, and the arrow keys its role expects. Focus order follows the visual order, and focus never gets trapped, except inside an open modal.
- Focus visibility: a focus indicator is visible on every focusable element and has 3:1 contrast against its surroundings (WCAG 2.4.7, 1.4.11).
- Focus management: focus moves into dialogs and menus when they open, and returns to the trigger when they close.
- Hover and focus content: tooltips and popovers can be dismissed, can be hovered, and stay visible until dismissed (WCAG 1.4.13).
- Reflow: no content or function is lost at 320px width (WCAG 1.4.10).
- Non-text contrast: control borders, icons, and states have 3:1 contrast (WCAG 1.4.11).
- Status messages: toasts and async results are announced through a live region (WCAG 4.1.3).

## Output

One line per rule that applies, using the axe rule ID:

```text
button-name     PASS
color-contrast  FAIL blocking   site/src/pages/FooPage/Foo.tsx:42  muted text on surface-secondary is 3.9:1 (story Foo/Default, dark theme)
target-size     FAIL should-fix site/src/components/Link/Link.tsx:18  18px tall in text-xs callers
manual:focus    FAIL blocking   site/src/.../Menu.tsx:30  focus not returned to trigger on close
Notes (pre-existing): heading-order in site/src/pages/Bar.tsx:12
```

After fixes, print the table again. In self-review mode, the audit is done when no `blocking` or `should-fix` line remains.
