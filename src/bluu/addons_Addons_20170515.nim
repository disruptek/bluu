
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Azure Addons Resource Provider
## version: 2017-05-15
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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  macServiceName = "addons-Addons"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_OperationsList_593646 = ref object of OpenApiRestCall_593424
proc url_OperationsList_593648(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_593647(path: JsonNode; query: JsonNode;
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
  var valid_593807 = query.getOrDefault("api-version")
  valid_593807 = validateParameter(valid_593807, JString, required = true,
                                 default = nil)
  if valid_593807 != nil:
    section.add "api-version", valid_593807
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593830: Call_OperationsList_593646; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available Addons RP operations.
  ## 
  let valid = call_593830.validator(path, query, header, formData, body)
  let scheme = call_593830.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593830.url(scheme.get, call_593830.host, call_593830.base,
                         call_593830.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593830, url, valid)

proc call*(call_593901: Call_OperationsList_593646; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available Addons RP operations.
  ##   apiVersion: string (required)
  ##             : Client API version.
  var query_593902 = newJObject()
  add(query_593902, "api-version", newJString(apiVersion))
  result = call_593901.call(nil, query_593902, nil, nil, nil)

var operationsList* = Call_OperationsList_593646(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Addons/operations",
    validator: validate_OperationsList_593647, base: "", url: url_OperationsList_593648,
    schemes: {Scheme.Https})
type
  Call_CanonicalSupportPlanTypesGet_593942 = ref object of OpenApiRestCall_593424
proc url_CanonicalSupportPlanTypesGet_593944(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "providerName" in path, "`providerName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Addons/supportProviders/"),
               (kind: VariableSegment, value: "providerName"),
               (kind: ConstantSegment, value: "/supportPlanTypes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CanonicalSupportPlanTypesGet_593943(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the Canonical Support Plans as well as whether they are enabled or not for the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   providerName: JString (required)
  ##               : The support plan type. For now the only valid type is "canonical".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_593959 = path.getOrDefault("subscriptionId")
  valid_593959 = validateParameter(valid_593959, JString, required = true,
                                 default = nil)
  if valid_593959 != nil:
    section.add "subscriptionId", valid_593959
  var valid_593960 = path.getOrDefault("providerName")
  valid_593960 = validateParameter(valid_593960, JString, required = true,
                                 default = nil)
  if valid_593960 != nil:
    section.add "providerName", valid_593960
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593961 = query.getOrDefault("api-version")
  valid_593961 = validateParameter(valid_593961, JString, required = true,
                                 default = nil)
  if valid_593961 != nil:
    section.add "api-version", valid_593961
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593962: Call_CanonicalSupportPlanTypesGet_593942; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the Canonical Support Plans as well as whether they are enabled or not for the subscription.
  ## 
  let valid = call_593962.validator(path, query, header, formData, body)
  let scheme = call_593962.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593962.url(scheme.get, call_593962.host, call_593962.base,
                         call_593962.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593962, url, valid)

proc call*(call_593963: Call_CanonicalSupportPlanTypesGet_593942;
          apiVersion: string; subscriptionId: string; providerName: string): Recallable =
  ## canonicalSupportPlanTypesGet
  ## Returns the Canonical Support Plans as well as whether they are enabled or not for the subscription.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   providerName: string (required)
  ##               : The support plan type. For now the only valid type is "canonical".
  var path_593964 = newJObject()
  var query_593965 = newJObject()
  add(query_593965, "api-version", newJString(apiVersion))
  add(path_593964, "subscriptionId", newJString(subscriptionId))
  add(path_593964, "providerName", newJString(providerName))
  result = call_593963.call(path_593964, query_593965, nil, nil, nil)

var canonicalSupportPlanTypesGet* = Call_CanonicalSupportPlanTypesGet_593942(
    name: "canonicalSupportPlanTypesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Addons/supportProviders/{providerName}/supportPlanTypes",
    validator: validate_CanonicalSupportPlanTypesGet_593943, base: "",
    url: url_CanonicalSupportPlanTypesGet_593944, schemes: {Scheme.Https})
type
  Call_SupportPlanTypesCreateOrUpdate_593990 = ref object of OpenApiRestCall_593424
proc url_SupportPlanTypesCreateOrUpdate_593992(protocol: Scheme; host: string;
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

proc validate_SupportPlanTypesCreateOrUpdate_593991(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates or updates the Canonical support plan of type {type} for the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   planTypeName: JString (required)
  ##               : The Canonical support plan type.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   providerName: JString (required)
  ##               : The support plan type. For now the only valid type is "canonical".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `planTypeName` field"
  var valid_593993 = path.getOrDefault("planTypeName")
  valid_593993 = validateParameter(valid_593993, JString, required = true,
                                 default = newJString("Essential"))
  if valid_593993 != nil:
    section.add "planTypeName", valid_593993
  var valid_593994 = path.getOrDefault("subscriptionId")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "subscriptionId", valid_593994
  var valid_593995 = path.getOrDefault("providerName")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "providerName", valid_593995
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593996 = query.getOrDefault("api-version")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "api-version", valid_593996
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593997: Call_SupportPlanTypesCreateOrUpdate_593990; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates or updates the Canonical support plan of type {type} for the subscription.
  ## 
  let valid = call_593997.validator(path, query, header, formData, body)
  let scheme = call_593997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593997.url(scheme.get, call_593997.host, call_593997.base,
                         call_593997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593997, url, valid)

proc call*(call_593998: Call_SupportPlanTypesCreateOrUpdate_593990;
          apiVersion: string; subscriptionId: string; providerName: string;
          planTypeName: string = "Essential"): Recallable =
  ## supportPlanTypesCreateOrUpdate
  ## Creates or updates the Canonical support plan of type {type} for the subscription.
  ##   planTypeName: string (required)
  ##               : The Canonical support plan type.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   providerName: string (required)
  ##               : The support plan type. For now the only valid type is "canonical".
  var path_593999 = newJObject()
  var query_594000 = newJObject()
  add(path_593999, "planTypeName", newJString(planTypeName))
  add(query_594000, "api-version", newJString(apiVersion))
  add(path_593999, "subscriptionId", newJString(subscriptionId))
  add(path_593999, "providerName", newJString(providerName))
  result = call_593998.call(path_593999, query_594000, nil, nil, nil)

var supportPlanTypesCreateOrUpdate* = Call_SupportPlanTypesCreateOrUpdate_593990(
    name: "supportPlanTypesCreateOrUpdate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Addons/supportProviders/{providerName}/supportPlanTypes/{planTypeName}",
    validator: validate_SupportPlanTypesCreateOrUpdate_593991, base: "",
    url: url_SupportPlanTypesCreateOrUpdate_593992, schemes: {Scheme.Https})
type
  Call_SupportPlanTypesGet_593966 = ref object of OpenApiRestCall_593424
proc url_SupportPlanTypesGet_593968(protocol: Scheme; host: string; base: string;
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

proc validate_SupportPlanTypesGet_593967(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Returns whether or not the canonical support plan of type {type} is enabled for the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   planTypeName: JString (required)
  ##               : The Canonical support plan type.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   providerName: JString (required)
  ##               : The support plan type. For now the only valid type is "canonical".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `planTypeName` field"
  var valid_593982 = path.getOrDefault("planTypeName")
  valid_593982 = validateParameter(valid_593982, JString, required = true,
                                 default = newJString("Essential"))
  if valid_593982 != nil:
    section.add "planTypeName", valid_593982
  var valid_593983 = path.getOrDefault("subscriptionId")
  valid_593983 = validateParameter(valid_593983, JString, required = true,
                                 default = nil)
  if valid_593983 != nil:
    section.add "subscriptionId", valid_593983
  var valid_593984 = path.getOrDefault("providerName")
  valid_593984 = validateParameter(valid_593984, JString, required = true,
                                 default = nil)
  if valid_593984 != nil:
    section.add "providerName", valid_593984
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593985 = query.getOrDefault("api-version")
  valid_593985 = validateParameter(valid_593985, JString, required = true,
                                 default = nil)
  if valid_593985 != nil:
    section.add "api-version", valid_593985
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593986: Call_SupportPlanTypesGet_593966; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns whether or not the canonical support plan of type {type} is enabled for the subscription.
  ## 
  let valid = call_593986.validator(path, query, header, formData, body)
  let scheme = call_593986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593986.url(scheme.get, call_593986.host, call_593986.base,
                         call_593986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593986, url, valid)

proc call*(call_593987: Call_SupportPlanTypesGet_593966; apiVersion: string;
          subscriptionId: string; providerName: string;
          planTypeName: string = "Essential"): Recallable =
  ## supportPlanTypesGet
  ## Returns whether or not the canonical support plan of type {type} is enabled for the subscription.
  ##   planTypeName: string (required)
  ##               : The Canonical support plan type.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   providerName: string (required)
  ##               : The support plan type. For now the only valid type is "canonical".
  var path_593988 = newJObject()
  var query_593989 = newJObject()
  add(path_593988, "planTypeName", newJString(planTypeName))
  add(query_593989, "api-version", newJString(apiVersion))
  add(path_593988, "subscriptionId", newJString(subscriptionId))
  add(path_593988, "providerName", newJString(providerName))
  result = call_593987.call(path_593988, query_593989, nil, nil, nil)

var supportPlanTypesGet* = Call_SupportPlanTypesGet_593966(
    name: "supportPlanTypesGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Addons/supportProviders/{providerName}/supportPlanTypes/{planTypeName}",
    validator: validate_SupportPlanTypesGet_593967, base: "",
    url: url_SupportPlanTypesGet_593968, schemes: {Scheme.Https})
type
  Call_SupportPlanTypesDelete_594001 = ref object of OpenApiRestCall_593424
proc url_SupportPlanTypesDelete_594003(protocol: Scheme; host: string; base: string;
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

proc validate_SupportPlanTypesDelete_594002(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Cancels the Canonical support plan of type {type} for the subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   planTypeName: JString (required)
  ##               : The Canonical support plan type.
  ##   subscriptionId: JString (required)
  ##                 : Subscription credentials that uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   providerName: JString (required)
  ##               : The support plan type. For now the only valid type is "canonical".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `planTypeName` field"
  var valid_594004 = path.getOrDefault("planTypeName")
  valid_594004 = validateParameter(valid_594004, JString, required = true,
                                 default = newJString("Essential"))
  if valid_594004 != nil:
    section.add "planTypeName", valid_594004
  var valid_594005 = path.getOrDefault("subscriptionId")
  valid_594005 = validateParameter(valid_594005, JString, required = true,
                                 default = nil)
  if valid_594005 != nil:
    section.add "subscriptionId", valid_594005
  var valid_594006 = path.getOrDefault("providerName")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "providerName", valid_594006
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client API version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594007 = query.getOrDefault("api-version")
  valid_594007 = validateParameter(valid_594007, JString, required = true,
                                 default = nil)
  if valid_594007 != nil:
    section.add "api-version", valid_594007
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594008: Call_SupportPlanTypesDelete_594001; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Cancels the Canonical support plan of type {type} for the subscription.
  ## 
  let valid = call_594008.validator(path, query, header, formData, body)
  let scheme = call_594008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594008.url(scheme.get, call_594008.host, call_594008.base,
                         call_594008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594008, url, valid)

proc call*(call_594009: Call_SupportPlanTypesDelete_594001; apiVersion: string;
          subscriptionId: string; providerName: string;
          planTypeName: string = "Essential"): Recallable =
  ## supportPlanTypesDelete
  ## Cancels the Canonical support plan of type {type} for the subscription.
  ##   planTypeName: string (required)
  ##               : The Canonical support plan type.
  ##   apiVersion: string (required)
  ##             : Client API version.
  ##   subscriptionId: string (required)
  ##                 : Subscription credentials that uniquely identify the Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   providerName: string (required)
  ##               : The support plan type. For now the only valid type is "canonical".
  var path_594010 = newJObject()
  var query_594011 = newJObject()
  add(path_594010, "planTypeName", newJString(planTypeName))
  add(query_594011, "api-version", newJString(apiVersion))
  add(path_594010, "subscriptionId", newJString(subscriptionId))
  add(path_594010, "providerName", newJString(providerName))
  result = call_594009.call(path_594010, query_594011, nil, nil, nil)

var supportPlanTypesDelete* = Call_SupportPlanTypesDelete_594001(
    name: "supportPlanTypesDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Addons/supportProviders/{providerName}/supportPlanTypes/{planTypeName}",
    validator: validate_SupportPlanTypesDelete_594002, base: "",
    url: url_SupportPlanTypesDelete_594003, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
