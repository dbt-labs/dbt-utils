# FORMAT AND STRUCTURE OF DECISION RECORDS

## CONTEXT
We previousy decicded to record any decisions made in this project using Nygard's architecture decision record (ADR) format. Should we continue with this format or adopt an alternative?

There are multiple options for formatting:
* [MADR 3.0.0-beta.2](https://github.com/adr/madr/blob/3.0.0-beta.2/template/adr-template.md) – Markdown Any Decision Records
* [Michael Nygard's template](http://thinkrelevance.com/blog/2011/11/15/documenting-architecture-decisions) – What we are using currently
* [Sustainable Architectural Decisions](https://www.infoq.com/articles/sustainable-architectural-design-decisions) – The Y-Statements
* Other templates listed at <https://github.com/joelparkerhenderson/architecture_decision_record>

If we choose to adopt a new format, we'll need to also choose whether to re-format previous decisions. The two main options are:
1. Keep the original formatting
1. Re-format all previous records according to MADR

Keeping the original formatting would have the benefit of not altering Nygard's original post, which was adopted as-is for its elegant self-describing nature. It would have the downside of inconsistent formatting though.

Re-formatting would resolve consistency at the cost of altering Nygard's original work.

## DECISION
Chosen option: "MADR 3.0.0-beta.2", because

* MADR is a matured version of the original ADR proposal that represents the state-of-the-art for ADR.
* MADR has ongoing development and is maintained similar to a software project.
* MADR explicitly uses Markdown, which is easy to read and write.
* MADR 3.0 (optionally) contains structured elements in a YAML block for machine-readability.

* MADR allows for structured capturing of any decision.
* The MADR project is active and continues to iterate with new versions.
* The MADR project itself is maintained like sofware with specifications and new versions.

Choosen option: "keep original formatting", because it feels special and deserves to be celebrated, even if there is slight inconsistency of formatting as a result. This decision is easily reversible in the future, if need be.

## STATUS
Accepted.

## CONSEQUENCES
New decisions will follow the MADR 3.0.0-beta.2 format, and we will update this decision and following decisions once MADR 3.0.0 is officially released. However, previous decisions may retain the original Nygard format. All decision records will be renamed according to MADR conventions including moving from `doc/arch` to `docs/decisions`.
