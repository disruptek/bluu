
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: ApplicationInsightsManagementClient
## version: 2017-10-01
## termsOfService: (not provided)
## license: (not provided)
## 
## Apis for customer in enterprise agreement migrate to new pricing model or rollback to legacy pricing model.
## 
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_596457 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_596457](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_596457): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "applicationinsights-eaSubscriptionMigration_API"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_EasubscriptionListMigrationDatePost_596679 = ref object of OpenApiRestCall_596457
proc url_EasubscriptionListMigrationDatePost_596681(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/microsoft.insights/listMigrationdate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EasubscriptionListMigrationDatePost_596680(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## list date to migrate to new pricing model.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_596841 = path.getOrDefault("subscriptionId")
  valid_596841 = validateParameter(valid_596841, JString, required = true,
                                 default = nil)
  if valid_596841 != nil:
    section.add "subscriptionId", valid_596841
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596842 = query.getOrDefault("api-version")
  valid_596842 = validateParameter(valid_596842, JString, required = true,
                                 default = nil)
  if valid_596842 != nil:
    section.add "api-version", valid_596842
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596869: Call_EasubscriptionListMigrationDatePost_596679;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## list date to migrate to new pricing model.
  ## 
  let valid = call_596869.validator(path, query, header, formData, body)
  let scheme = call_596869.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596869.url(scheme.get, call_596869.host, call_596869.base,
                         call_596869.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596869, url, valid)

proc call*(call_596940: Call_EasubscriptionListMigrationDatePost_596679;
          apiVersion: string; subscriptionId: string): Recallable =
  ## easubscriptionListMigrationDatePost
  ## list date to migrate to new pricing model.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_596941 = newJObject()
  var query_596943 = newJObject()
  add(query_596943, "api-version", newJString(apiVersion))
  add(path_596941, "subscriptionId", newJString(subscriptionId))
  result = call_596940.call(path_596941, query_596943, nil, nil, nil)

var easubscriptionListMigrationDatePost* = Call_EasubscriptionListMigrationDatePost_596679(
    name: "easubscriptionListMigrationDatePost", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/microsoft.insights/listMigrationdate",
    validator: validate_EasubscriptionListMigrationDatePost_596680, base: "",
    url: url_EasubscriptionListMigrationDatePost_596681, schemes: {Scheme.Https})
type
  Call_EasubscriptionMigrateToNewPricingModelPost_596982 = ref object of OpenApiRestCall_596457
proc url_EasubscriptionMigrateToNewPricingModelPost_596984(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/microsoft.insights/migrateToNewPricingModel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EasubscriptionMigrateToNewPricingModelPost_596983(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Enterprise Agreement Customer opted to use new pricing model.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_596985 = path.getOrDefault("subscriptionId")
  valid_596985 = validateParameter(valid_596985, JString, required = true,
                                 default = nil)
  if valid_596985 != nil:
    section.add "subscriptionId", valid_596985
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596986 = query.getOrDefault("api-version")
  valid_596986 = validateParameter(valid_596986, JString, required = true,
                                 default = nil)
  if valid_596986 != nil:
    section.add "api-version", valid_596986
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596987: Call_EasubscriptionMigrateToNewPricingModelPost_596982;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enterprise Agreement Customer opted to use new pricing model.
  ## 
  let valid = call_596987.validator(path, query, header, formData, body)
  let scheme = call_596987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596987.url(scheme.get, call_596987.host, call_596987.base,
                         call_596987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596987, url, valid)

proc call*(call_596988: Call_EasubscriptionMigrateToNewPricingModelPost_596982;
          apiVersion: string; subscriptionId: string): Recallable =
  ## easubscriptionMigrateToNewPricingModelPost
  ## Enterprise Agreement Customer opted to use new pricing model.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_596989 = newJObject()
  var query_596990 = newJObject()
  add(query_596990, "api-version", newJString(apiVersion))
  add(path_596989, "subscriptionId", newJString(subscriptionId))
  result = call_596988.call(path_596989, query_596990, nil, nil, nil)

var easubscriptionMigrateToNewPricingModelPost* = Call_EasubscriptionMigrateToNewPricingModelPost_596982(
    name: "easubscriptionMigrateToNewPricingModelPost", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/microsoft.insights/migrateToNewPricingModel",
    validator: validate_EasubscriptionMigrateToNewPricingModelPost_596983,
    base: "", url: url_EasubscriptionMigrateToNewPricingModelPost_596984,
    schemes: {Scheme.Https})
type
  Call_EasubscriptionRollbackToLegacyPricingModelPost_596991 = ref object of OpenApiRestCall_596457
proc url_EasubscriptionRollbackToLegacyPricingModelPost_596993(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/microsoft.insights/rollbackToLegacyPricingModel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EasubscriptionRollbackToLegacyPricingModelPost_596992(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Enterprise Agreement Customer roll back to use legacy pricing model.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : The ID of the target subscription.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_596994 = path.getOrDefault("subscriptionId")
  valid_596994 = validateParameter(valid_596994, JString, required = true,
                                 default = nil)
  if valid_596994 != nil:
    section.add "subscriptionId", valid_596994
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : The API version to use for this operation.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_596995 = query.getOrDefault("api-version")
  valid_596995 = validateParameter(valid_596995, JString, required = true,
                                 default = nil)
  if valid_596995 != nil:
    section.add "api-version", valid_596995
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_596996: Call_EasubscriptionRollbackToLegacyPricingModelPost_596991;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enterprise Agreement Customer roll back to use legacy pricing model.
  ## 
  let valid = call_596996.validator(path, query, header, formData, body)
  let scheme = call_596996.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_596996.url(scheme.get, call_596996.host, call_596996.base,
                         call_596996.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_596996, url, valid)

proc call*(call_596997: Call_EasubscriptionRollbackToLegacyPricingModelPost_596991;
          apiVersion: string; subscriptionId: string): Recallable =
  ## easubscriptionRollbackToLegacyPricingModelPost
  ## Enterprise Agreement Customer roll back to use legacy pricing model.
  ##   apiVersion: string (required)
  ##             : The API version to use for this operation.
  ##   subscriptionId: string (required)
  ##                 : The ID of the target subscription.
  var path_596998 = newJObject()
  var query_596999 = newJObject()
  add(query_596999, "api-version", newJString(apiVersion))
  add(path_596998, "subscriptionId", newJString(subscriptionId))
  result = call_596997.call(path_596998, query_596999, nil, nil, nil)

var easubscriptionRollbackToLegacyPricingModelPost* = Call_EasubscriptionRollbackToLegacyPricingModelPost_596991(
    name: "easubscriptionRollbackToLegacyPricingModelPost",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/microsoft.insights/rollbackToLegacyPricingModel",
    validator: validate_EasubscriptionRollbackToLegacyPricingModelPost_596992,
    base: "", url: url_EasubscriptionRollbackToLegacyPricingModelPost_596993,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
