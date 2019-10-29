
import
  json, options, hashes, uri, rest, os, uri, httpcore

## auto-generated via openapi macro
## title: Azure Addons Resource Provider
## version: 2018-03-01
## termsOfService: (not provided)
## license: (not provided)
## 
## The service for managing third party addons.
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

  OpenApiRestCall_563555 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_563555](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_563555): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  macServiceName = "addons-addons-swagger"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_563777 = ref object of OpenApiRestCall_563555
proc url_OperationsList_563779(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_563778(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available Addons RP operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563940 = query.getOrDefault("api-version")
  valid_563940 = validateParameter(valid_563940, JString, required = true,
                                 default = nil)
  if valid_563940 != nil:
    section.add "api-version", valid_563940
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563963: Call_OperationsList_563777; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Addons RP operations.
  ## 
  let valid = call_563963.validator(path, query, header, formData, body)
  let scheme = call_563963.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563963.url(scheme.get, call_563963.host, call_563963.base,
                         call_563963.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563963, url, valid)

proc call*(call_564034: Call_OperationsList_563777; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Addons RP operations.
  ##   apiVersion: string (required)
  ##             : Client API version.
  var query_564035 = newJObject()
  add(query_564035, "api-version", newJString(apiVersion))
  result = call_564034.call(nil, query_564035, nil, nil, nil)

var operationsList* = Call_OperationsList_563777(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Addons/operations",
    validator: validate_OperationsList_563778, base: "", url: url_OperationsList_563779,
    schemes: {Scheme.Https})
type
  Call_SupportPlanTypesListInfo_564075 = ref object of OpenApiRestCall_563555
proc url_SupportPlanTypesListInfo_564077(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Addons/supportProviders/canonical/listSupportPlanInfo")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SupportPlanTypesListInfo_564076(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the canonical support plan information for all types for the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_564092 = path.getOrDefault("subscriptionId")
  valid_564092 = validateParameter(valid_564092, JString, required = true,
                                 default = nil)
  if valid_564092 != nil:
    section.add "subscriptionId", valid_564092
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564093 = query.getOrDefault("api-version")
  valid_564093 = validateParameter(valid_564093, JString, required = true,
                                 default = nil)
  if valid_564093 != nil:
    section.add "api-version", valid_564093
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564094: Call_SupportPlanTypesListInfo_564075; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the canonical support plan information for all types for the subscription.
  ## 
  let valid = call_564094.validator(path, query, header, formData, body)
  let scheme = call_564094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564094.url(scheme.get, call_564094.host, call_564094.base,
                         call_564094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564094, url, valid)

proc call*(call_564095: Call_SupportPlanTypesListInfo_564075; apiVersion: string;
          subscriptionId: string): Recallable =
  ## supportPlanTypesListInfo
  ## Returns the canonical support plan information for all types for the subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  var path_564096 = newJObject()
  var query_564097 = newJObject()
  add(query_564097, "api-version", newJString(apiVersion))
  add(path_564096, "subscriptionId", newJString(subscriptionId))
  result = call_564095.call(path_564096, query_564097, nil, nil, nil)

var supportPlanTypesListInfo* = Call_SupportPlanTypesListInfo_564075(
    name: "supportPlanTypesListInfo", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Addons/supportProviders/canonical/listSupportPlanInfo",
    validator: validate_SupportPlanTypesListInfo_564076, base: "",
    url: url_SupportPlanTypesListInfo_564077, schemes: {Scheme.Https})
type
  Call_SupportPlanTypesCreateOrUpdate_564122 = ref object of OpenApiRestCall_563555
proc url_SupportPlanTypesCreateOrUpdate_564124(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "providerName" in path, "`providerName` is a required path parameter"
  assert "planTypeName" in path, "`planTypeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Addons/supportProviders/"),
               (kind: VariableSegment, value: "providerName"),
               (kind: ConstantSegment, value: "/supportPlanTypes/"),
               (kind: VariableSegment, value: "planTypeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SupportPlanTypesCreateOrUpdate_564123(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the Canonical support plan of type {type} for the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   providerName: JString (required)
  ##               : The support plan type. For now the only valid type is "canonical".
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   planTypeName: JString (required)
  ##               : The Canonical support plan type.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `providerName` field"
  var valid_564125 = path.getOrDefault("providerName")
  valid_564125 = validateParameter(valid_564125, JString, required = true,
                                 default = nil)
  if valid_564125 != nil:
    section.add "providerName", valid_564125
  var valid_564126 = path.getOrDefault("subscriptionId")
  valid_564126 = validateParameter(valid_564126, JString, required = true,
                                 default = nil)
  if valid_564126 != nil:
    section.add "subscriptionId", valid_564126
  var valid_564127 = path.getOrDefault("planTypeName")
  valid_564127 = validateParameter(valid_564127, JString, required = true,
                                 default = newJString("Essential"))
  if valid_564127 != nil:
    section.add "planTypeName", valid_564127
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564128 = query.getOrDefault("api-version")
  valid_564128 = validateParameter(valid_564128, JString, required = true,
                                 default = nil)
  if valid_564128 != nil:
    section.add "api-version", valid_564128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564129: Call_SupportPlanTypesCreateOrUpdate_564122; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the Canonical support plan of type {type} for the subscription.
  ## 
  let valid = call_564129.validator(path, query, header, formData, body)
  let scheme = call_564129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564129.url(scheme.get, call_564129.host, call_564129.base,
                         call_564129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564129, url, valid)

proc call*(call_564130: Call_SupportPlanTypesCreateOrUpdate_564122;
          providerName: string; apiVersion: string; subscriptionId: string;
          planTypeName: string = "Essential"): Recallable =
  ## supportPlanTypesCreateOrUpdate
  ## Creates or updates the Canonical support plan of type {type} for the subscription.
  ##   providerName: string (required)
  ##               : The support plan type. For now the only valid type is "canonical".
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   planTypeName: string (required)
  ##               : The Canonical support plan type.
  var path_564131 = newJObject()
  var query_564132 = newJObject()
  add(path_564131, "providerName", newJString(providerName))
  add(query_564132, "api-version", newJString(apiVersion))
  add(path_564131, "subscriptionId", newJString(subscriptionId))
  add(path_564131, "planTypeName", newJString(planTypeName))
  result = call_564130.call(path_564131, query_564132, nil, nil, nil)

var supportPlanTypesCreateOrUpdate* = Call_SupportPlanTypesCreateOrUpdate_564122(
    name: "supportPlanTypesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Addons/supportProviders/{providerName}/supportPlanTypes/{planTypeName}",
    validator: validate_SupportPlanTypesCreateOrUpdate_564123, base: "",
    url: url_SupportPlanTypesCreateOrUpdate_564124, schemes: {Scheme.Https})
type
  Call_SupportPlanTypesGet_564098 = ref object of OpenApiRestCall_563555
proc url_SupportPlanTypesGet_564100(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "providerName" in path, "`providerName` is a required path parameter"
  assert "planTypeName" in path, "`planTypeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Addons/supportProviders/"),
               (kind: VariableSegment, value: "providerName"),
               (kind: ConstantSegment, value: "/supportPlanTypes/"),
               (kind: VariableSegment, value: "planTypeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SupportPlanTypesGet_564099(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Returns whether or not the canonical support plan of type {type} is enabled for the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   providerName: JString (required)
  ##               : The support plan type. For now the only valid type is "canonical".
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   planTypeName: JString (required)
  ##               : The Canonical support plan type.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `providerName` field"
  var valid_564101 = path.getOrDefault("providerName")
  valid_564101 = validateParameter(valid_564101, JString, required = true,
                                 default = nil)
  if valid_564101 != nil:
    section.add "providerName", valid_564101
  var valid_564102 = path.getOrDefault("subscriptionId")
  valid_564102 = validateParameter(valid_564102, JString, required = true,
                                 default = nil)
  if valid_564102 != nil:
    section.add "subscriptionId", valid_564102
  var valid_564116 = path.getOrDefault("planTypeName")
  valid_564116 = validateParameter(valid_564116, JString, required = true,
                                 default = newJString("Essential"))
  if valid_564116 != nil:
    section.add "planTypeName", valid_564116
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564117 = query.getOrDefault("api-version")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = nil)
  if valid_564117 != nil:
    section.add "api-version", valid_564117
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564118: Call_SupportPlanTypesGet_564098; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns whether or not the canonical support plan of type {type} is enabled for the subscription.
  ## 
  let valid = call_564118.validator(path, query, header, formData, body)
  let scheme = call_564118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564118.url(scheme.get, call_564118.host, call_564118.base,
                         call_564118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564118, url, valid)

proc call*(call_564119: Call_SupportPlanTypesGet_564098; providerName: string;
          apiVersion: string; subscriptionId: string;
          planTypeName: string = "Essential"): Recallable =
  ## supportPlanTypesGet
  ## Returns whether or not the canonical support plan of type {type} is enabled for the subscription.
  ##   providerName: string (required)
  ##               : The support plan type. For now the only valid type is "canonical".
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   planTypeName: string (required)
  ##               : The Canonical support plan type.
  var path_564120 = newJObject()
  var query_564121 = newJObject()
  add(path_564120, "providerName", newJString(providerName))
  add(query_564121, "api-version", newJString(apiVersion))
  add(path_564120, "subscriptionId", newJString(subscriptionId))
  add(path_564120, "planTypeName", newJString(planTypeName))
  result = call_564119.call(path_564120, query_564121, nil, nil, nil)

var supportPlanTypesGet* = Call_SupportPlanTypesGet_564098(
    name: "supportPlanTypesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Addons/supportProviders/{providerName}/supportPlanTypes/{planTypeName}",
    validator: validate_SupportPlanTypesGet_564099, base: "",
    url: url_SupportPlanTypesGet_564100, schemes: {Scheme.Https})
type
  Call_SupportPlanTypesDelete_564133 = ref object of OpenApiRestCall_563555
proc url_SupportPlanTypesDelete_564135(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "providerName" in path, "`providerName` is a required path parameter"
  assert "planTypeName" in path, "`planTypeName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Addons/supportProviders/"),
               (kind: VariableSegment, value: "providerName"),
               (kind: ConstantSegment, value: "/supportPlanTypes/"),
               (kind: VariableSegment, value: "planTypeName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SupportPlanTypesDelete_564134(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels the Canonical support plan of type {type} for the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   providerName: JString (required)
  ##               : The support plan type. For now the only valid type is "canonical".
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   planTypeName: JString (required)
  ##               : The Canonical support plan type.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `providerName` field"
  var valid_564136 = path.getOrDefault("providerName")
  valid_564136 = validateParameter(valid_564136, JString, required = true,
                                 default = nil)
  if valid_564136 != nil:
    section.add "providerName", valid_564136
  var valid_564137 = path.getOrDefault("subscriptionId")
  valid_564137 = validateParameter(valid_564137, JString, required = true,
                                 default = nil)
  if valid_564137 != nil:
    section.add "subscriptionId", valid_564137
  var valid_564138 = path.getOrDefault("planTypeName")
  valid_564138 = validateParameter(valid_564138, JString, required = true,
                                 default = newJString("Essential"))
  if valid_564138 != nil:
    section.add "planTypeName", valid_564138
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564139 = query.getOrDefault("api-version")
  valid_564139 = validateParameter(valid_564139, JString, required = true,
                                 default = nil)
  if valid_564139 != nil:
    section.add "api-version", valid_564139
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564140: Call_SupportPlanTypesDelete_564133; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels the Canonical support plan of type {type} for the subscription.
  ## 
  let valid = call_564140.validator(path, query, header, formData, body)
  let scheme = call_564140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564140.url(scheme.get, call_564140.host, call_564140.base,
                         call_564140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564140, url, valid)

proc call*(call_564141: Call_SupportPlanTypesDelete_564133; providerName: string;
          apiVersion: string; subscriptionId: string;
          planTypeName: string = "Essential"): Recallable =
  ## supportPlanTypesDelete
  ## Cancels the Canonical support plan of type {type} for the subscription.
  ##   providerName: string (required)
  ##               : The support plan type. For now the only valid type is "canonical".
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   planTypeName: string (required)
  ##               : The Canonical support plan type.
  var path_564142 = newJObject()
  var query_564143 = newJObject()
  add(path_564142, "providerName", newJString(providerName))
  add(query_564143, "api-version", newJString(apiVersion))
  add(path_564142, "subscriptionId", newJString(subscriptionId))
  add(path_564142, "planTypeName", newJString(planTypeName))
  result = call_564141.call(path_564142, query_564143, nil, nil, nil)

var supportPlanTypesDelete* = Call_SupportPlanTypesDelete_564133(
    name: "supportPlanTypesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Addons/supportProviders/{providerName}/supportPlanTypes/{planTypeName}",
    validator: validate_SupportPlanTypesDelete_564134, base: "",
    url: url_SupportPlanTypesDelete_564135, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
