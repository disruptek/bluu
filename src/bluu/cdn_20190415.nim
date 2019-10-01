
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: CdnManagementClient
## version: 2019-04-15
## termsOfService: (not provided)
## license: (not provided)
## 
## Use these APIs to manage Azure CDN resources through the Azure Resource Manager. You must make sure that requests made to these resources are secure.
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

  OpenApiRestCall_574467 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_574467](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_574467): Option[Scheme] {.used.} =
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
  macServiceName = "cdn"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CheckNameAvailability_574689 = ref object of OpenApiRestCall_574467
proc url_CheckNameAvailability_574691(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_CheckNameAvailability_574690(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Check the availability of a resource name. This is needed for resources where name is globally unique, such as a CDN endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574850 = query.getOrDefault("api-version")
  valid_574850 = validateParameter(valid_574850, JString, required = true,
                                 default = nil)
  if valid_574850 != nil:
    section.add "api-version", valid_574850
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   checkNameAvailabilityInput: JObject (required)
  ##                             : Input to check.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_574874: Call_CheckNameAvailability_574689; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Check the availability of a resource name. This is needed for resources where name is globally unique, such as a CDN endpoint.
  ## 
  let valid = call_574874.validator(path, query, header, formData, body)
  let scheme = call_574874.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574874.url(scheme.get, call_574874.host, call_574874.base,
                         call_574874.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574874, url, valid)

proc call*(call_574945: Call_CheckNameAvailability_574689; apiVersion: string;
          checkNameAvailabilityInput: JsonNode): Recallable =
  ## checkNameAvailability
  ## Check the availability of a resource name. This is needed for resources where name is globally unique, such as a CDN endpoint.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   checkNameAvailabilityInput: JObject (required)
  ##                             : Input to check.
  var query_574946 = newJObject()
  var body_574948 = newJObject()
  add(query_574946, "api-version", newJString(apiVersion))
  if checkNameAvailabilityInput != nil:
    body_574948 = checkNameAvailabilityInput
  result = call_574945.call(nil, query_574946, nil, nil, body_574948)

var checkNameAvailability* = Call_CheckNameAvailability_574689(
    name: "checkNameAvailability", meth: HttpMethod.HttpPost,
    host: "management.azure.com",
    route: "/providers/Microsoft.Cdn/checkNameAvailability",
    validator: validate_CheckNameAvailability_574690, base: "",
    url: url_CheckNameAvailability_574691, schemes: {Scheme.Https})
type
  Call_EdgeNodesList_574987 = ref object of OpenApiRestCall_574467
proc url_EdgeNodesList_574989(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_EdgeNodesList_574988(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Edgenodes are the global Point of Presence (POP) locations used to deliver CDN content to end users.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574990 = query.getOrDefault("api-version")
  valid_574990 = validateParameter(valid_574990, JString, required = true,
                                 default = nil)
  if valid_574990 != nil:
    section.add "api-version", valid_574990
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574991: Call_EdgeNodesList_574987; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Edgenodes are the global Point of Presence (POP) locations used to deliver CDN content to end users.
  ## 
  let valid = call_574991.validator(path, query, header, formData, body)
  let scheme = call_574991.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574991.url(scheme.get, call_574991.host, call_574991.base,
                         call_574991.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574991, url, valid)

proc call*(call_574992: Call_EdgeNodesList_574987; apiVersion: string): Recallable =
  ## edgeNodesList
  ## Edgenodes are the global Point of Presence (POP) locations used to deliver CDN content to end users.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  var query_574993 = newJObject()
  add(query_574993, "api-version", newJString(apiVersion))
  result = call_574992.call(nil, query_574993, nil, nil, nil)

var edgeNodesList* = Call_EdgeNodesList_574987(name: "edgeNodesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Cdn/edgenodes",
    validator: validate_EdgeNodesList_574988, base: "", url: url_EdgeNodesList_574989,
    schemes: {Scheme.Https})
type
  Call_OperationsList_574994 = ref object of OpenApiRestCall_574467
proc url_OperationsList_574996(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_OperationsList_574995(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Lists all of the available CDN REST API operations.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_574997 = query.getOrDefault("api-version")
  valid_574997 = validateParameter(valid_574997, JString, required = true,
                                 default = nil)
  if valid_574997 != nil:
    section.add "api-version", valid_574997
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_574998: Call_OperationsList_574994; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the available CDN REST API operations.
  ## 
  let valid = call_574998.validator(path, query, header, formData, body)
  let scheme = call_574998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_574998.url(scheme.get, call_574998.host, call_574998.base,
                         call_574998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_574998, url, valid)

proc call*(call_574999: Call_OperationsList_574994; apiVersion: string): Recallable =
  ## operationsList
  ## Lists all of the available CDN REST API operations.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  var query_575000 = newJObject()
  add(query_575000, "api-version", newJString(apiVersion))
  result = call_574999.call(nil, query_575000, nil, nil, nil)

var operationsList* = Call_OperationsList_574994(name: "operationsList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/providers/Microsoft.Cdn/operations",
    validator: validate_OperationsList_574995, base: "", url: url_OperationsList_574996,
    schemes: {Scheme.Https})
type
  Call_CheckNameAvailabilityWithSubscription_575001 = ref object of OpenApiRestCall_574467
proc url_CheckNameAvailabilityWithSubscription_575003(protocol: Scheme;
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
        value: "/providers/Microsoft.Cdn/checkNameAvailability")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CheckNameAvailabilityWithSubscription_575002(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Check the availability of a resource name. This is needed for resources where name is globally unique, such as a CDN endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_575018 = path.getOrDefault("subscriptionId")
  valid_575018 = validateParameter(valid_575018, JString, required = true,
                                 default = nil)
  if valid_575018 != nil:
    section.add "subscriptionId", valid_575018
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575019 = query.getOrDefault("api-version")
  valid_575019 = validateParameter(valid_575019, JString, required = true,
                                 default = nil)
  if valid_575019 != nil:
    section.add "api-version", valid_575019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   checkNameAvailabilityInput: JObject (required)
  ##                             : Input to check.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575021: Call_CheckNameAvailabilityWithSubscription_575001;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Check the availability of a resource name. This is needed for resources where name is globally unique, such as a CDN endpoint.
  ## 
  let valid = call_575021.validator(path, query, header, formData, body)
  let scheme = call_575021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575021.url(scheme.get, call_575021.host, call_575021.base,
                         call_575021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575021, url, valid)

proc call*(call_575022: Call_CheckNameAvailabilityWithSubscription_575001;
          apiVersion: string; subscriptionId: string;
          checkNameAvailabilityInput: JsonNode): Recallable =
  ## checkNameAvailabilityWithSubscription
  ## Check the availability of a resource name. This is needed for resources where name is globally unique, such as a CDN endpoint.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   checkNameAvailabilityInput: JObject (required)
  ##                             : Input to check.
  var path_575023 = newJObject()
  var query_575024 = newJObject()
  var body_575025 = newJObject()
  add(query_575024, "api-version", newJString(apiVersion))
  add(path_575023, "subscriptionId", newJString(subscriptionId))
  if checkNameAvailabilityInput != nil:
    body_575025 = checkNameAvailabilityInput
  result = call_575022.call(path_575023, query_575024, nil, nil, body_575025)

var checkNameAvailabilityWithSubscription* = Call_CheckNameAvailabilityWithSubscription_575001(
    name: "checkNameAvailabilityWithSubscription", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Cdn/checkNameAvailability",
    validator: validate_CheckNameAvailabilityWithSubscription_575002, base: "",
    url: url_CheckNameAvailabilityWithSubscription_575003, schemes: {Scheme.Https})
type
  Call_ResourceUsageList_575026 = ref object of OpenApiRestCall_574467
proc url_ResourceUsageList_575028(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Cdn/checkResourceUsage")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ResourceUsageList_575027(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Check the quota and actual usage of the CDN profiles under the given subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_575029 = path.getOrDefault("subscriptionId")
  valid_575029 = validateParameter(valid_575029, JString, required = true,
                                 default = nil)
  if valid_575029 != nil:
    section.add "subscriptionId", valid_575029
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575030 = query.getOrDefault("api-version")
  valid_575030 = validateParameter(valid_575030, JString, required = true,
                                 default = nil)
  if valid_575030 != nil:
    section.add "api-version", valid_575030
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575031: Call_ResourceUsageList_575026; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Check the quota and actual usage of the CDN profiles under the given subscription.
  ## 
  let valid = call_575031.validator(path, query, header, formData, body)
  let scheme = call_575031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575031.url(scheme.get, call_575031.host, call_575031.base,
                         call_575031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575031, url, valid)

proc call*(call_575032: Call_ResourceUsageList_575026; apiVersion: string;
          subscriptionId: string): Recallable =
  ## resourceUsageList
  ## Check the quota and actual usage of the CDN profiles under the given subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_575033 = newJObject()
  var query_575034 = newJObject()
  add(query_575034, "api-version", newJString(apiVersion))
  add(path_575033, "subscriptionId", newJString(subscriptionId))
  result = call_575032.call(path_575033, query_575034, nil, nil, nil)

var resourceUsageList* = Call_ResourceUsageList_575026(name: "resourceUsageList",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Cdn/checkResourceUsage",
    validator: validate_ResourceUsageList_575027, base: "",
    url: url_ResourceUsageList_575028, schemes: {Scheme.Https})
type
  Call_ProfilesList_575035 = ref object of OpenApiRestCall_574467
proc url_ProfilesList_575037(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesList_575036(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the CDN profiles within an Azure subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_575038 = path.getOrDefault("subscriptionId")
  valid_575038 = validateParameter(valid_575038, JString, required = true,
                                 default = nil)
  if valid_575038 != nil:
    section.add "subscriptionId", valid_575038
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575039 = query.getOrDefault("api-version")
  valid_575039 = validateParameter(valid_575039, JString, required = true,
                                 default = nil)
  if valid_575039 != nil:
    section.add "api-version", valid_575039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575040: Call_ProfilesList_575035; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the CDN profiles within an Azure subscription.
  ## 
  let valid = call_575040.validator(path, query, header, formData, body)
  let scheme = call_575040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575040.url(scheme.get, call_575040.host, call_575040.base,
                         call_575040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575040, url, valid)

proc call*(call_575041: Call_ProfilesList_575035; apiVersion: string;
          subscriptionId: string): Recallable =
  ## profilesList
  ## Lists all of the CDN profiles within an Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_575042 = newJObject()
  var query_575043 = newJObject()
  add(query_575043, "api-version", newJString(apiVersion))
  add(path_575042, "subscriptionId", newJString(subscriptionId))
  result = call_575041.call(path_575042, query_575043, nil, nil, nil)

var profilesList* = Call_ProfilesList_575035(name: "profilesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/providers/Microsoft.Cdn/profiles",
    validator: validate_ProfilesList_575036, base: "", url: url_ProfilesList_575037,
    schemes: {Scheme.Https})
type
  Call_ValidateProbe_575044 = ref object of OpenApiRestCall_574467
proc url_ValidateProbe_575046(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/validateProbe")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ValidateProbe_575045(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Check if the probe path is a valid path and the file can be accessed. Probe path is the path to a file hosted on the origin server to help accelerate the delivery of dynamic content via the CDN endpoint. This path is relative to the origin path specified in the endpoint configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscriptionId` field"
  var valid_575047 = path.getOrDefault("subscriptionId")
  valid_575047 = validateParameter(valid_575047, JString, required = true,
                                 default = nil)
  if valid_575047 != nil:
    section.add "subscriptionId", valid_575047
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575048 = query.getOrDefault("api-version")
  valid_575048 = validateParameter(valid_575048, JString, required = true,
                                 default = nil)
  if valid_575048 != nil:
    section.add "api-version", valid_575048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   validateProbeInput: JObject (required)
  ##                     : Input to check.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575050: Call_ValidateProbe_575044; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Check if the probe path is a valid path and the file can be accessed. Probe path is the path to a file hosted on the origin server to help accelerate the delivery of dynamic content via the CDN endpoint. This path is relative to the origin path specified in the endpoint configuration.
  ## 
  let valid = call_575050.validator(path, query, header, formData, body)
  let scheme = call_575050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575050.url(scheme.get, call_575050.host, call_575050.base,
                         call_575050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575050, url, valid)

proc call*(call_575051: Call_ValidateProbe_575044; apiVersion: string;
          subscriptionId: string; validateProbeInput: JsonNode): Recallable =
  ## validateProbe
  ## Check if the probe path is a valid path and the file can be accessed. Probe path is the path to a file hosted on the origin server to help accelerate the delivery of dynamic content via the CDN endpoint. This path is relative to the origin path specified in the endpoint configuration.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   validateProbeInput: JObject (required)
  ##                     : Input to check.
  var path_575052 = newJObject()
  var query_575053 = newJObject()
  var body_575054 = newJObject()
  add(query_575053, "api-version", newJString(apiVersion))
  add(path_575052, "subscriptionId", newJString(subscriptionId))
  if validateProbeInput != nil:
    body_575054 = validateProbeInput
  result = call_575051.call(path_575052, query_575053, nil, nil, body_575054)

var validateProbe* = Call_ValidateProbe_575044(name: "validateProbe",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Cdn/validateProbe",
    validator: validate_ValidateProbe_575045, base: "", url: url_ValidateProbe_575046,
    schemes: {Scheme.Https})
type
  Call_ProfilesListByResourceGroup_575055 = ref object of OpenApiRestCall_574467
proc url_ProfilesListByResourceGroup_575057(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesListByResourceGroup_575056(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the CDN profiles within a resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575058 = path.getOrDefault("resourceGroupName")
  valid_575058 = validateParameter(valid_575058, JString, required = true,
                                 default = nil)
  if valid_575058 != nil:
    section.add "resourceGroupName", valid_575058
  var valid_575059 = path.getOrDefault("subscriptionId")
  valid_575059 = validateParameter(valid_575059, JString, required = true,
                                 default = nil)
  if valid_575059 != nil:
    section.add "subscriptionId", valid_575059
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575060 = query.getOrDefault("api-version")
  valid_575060 = validateParameter(valid_575060, JString, required = true,
                                 default = nil)
  if valid_575060 != nil:
    section.add "api-version", valid_575060
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575061: Call_ProfilesListByResourceGroup_575055; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the CDN profiles within a resource group.
  ## 
  let valid = call_575061.validator(path, query, header, formData, body)
  let scheme = call_575061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575061.url(scheme.get, call_575061.host, call_575061.base,
                         call_575061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575061, url, valid)

proc call*(call_575062: Call_ProfilesListByResourceGroup_575055;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## profilesListByResourceGroup
  ## Lists all of the CDN profiles within a resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_575063 = newJObject()
  var query_575064 = newJObject()
  add(path_575063, "resourceGroupName", newJString(resourceGroupName))
  add(query_575064, "api-version", newJString(apiVersion))
  add(path_575063, "subscriptionId", newJString(subscriptionId))
  result = call_575062.call(path_575063, query_575064, nil, nil, nil)

var profilesListByResourceGroup* = Call_ProfilesListByResourceGroup_575055(
    name: "profilesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles",
    validator: validate_ProfilesListByResourceGroup_575056, base: "",
    url: url_ProfilesListByResourceGroup_575057, schemes: {Scheme.Https})
type
  Call_ProfilesCreate_575076 = ref object of OpenApiRestCall_574467
proc url_ProfilesCreate_575078(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesCreate_575077(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Creates a new CDN profile with a profile name under the specified subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575079 = path.getOrDefault("resourceGroupName")
  valid_575079 = validateParameter(valid_575079, JString, required = true,
                                 default = nil)
  if valid_575079 != nil:
    section.add "resourceGroupName", valid_575079
  var valid_575080 = path.getOrDefault("subscriptionId")
  valid_575080 = validateParameter(valid_575080, JString, required = true,
                                 default = nil)
  if valid_575080 != nil:
    section.add "subscriptionId", valid_575080
  var valid_575081 = path.getOrDefault("profileName")
  valid_575081 = validateParameter(valid_575081, JString, required = true,
                                 default = nil)
  if valid_575081 != nil:
    section.add "profileName", valid_575081
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575082 = query.getOrDefault("api-version")
  valid_575082 = validateParameter(valid_575082, JString, required = true,
                                 default = nil)
  if valid_575082 != nil:
    section.add "api-version", valid_575082
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   profile: JObject (required)
  ##          : Profile properties needed to create a new profile.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575084: Call_ProfilesCreate_575076; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new CDN profile with a profile name under the specified subscription and resource group.
  ## 
  let valid = call_575084.validator(path, query, header, formData, body)
  let scheme = call_575084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575084.url(scheme.get, call_575084.host, call_575084.base,
                         call_575084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575084, url, valid)

proc call*(call_575085: Call_ProfilesCreate_575076; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; profileName: string;
          profile: JsonNode): Recallable =
  ## profilesCreate
  ## Creates a new CDN profile with a profile name under the specified subscription and resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   profile: JObject (required)
  ##          : Profile properties needed to create a new profile.
  var path_575086 = newJObject()
  var query_575087 = newJObject()
  var body_575088 = newJObject()
  add(path_575086, "resourceGroupName", newJString(resourceGroupName))
  add(query_575087, "api-version", newJString(apiVersion))
  add(path_575086, "subscriptionId", newJString(subscriptionId))
  add(path_575086, "profileName", newJString(profileName))
  if profile != nil:
    body_575088 = profile
  result = call_575085.call(path_575086, query_575087, nil, nil, body_575088)

var profilesCreate* = Call_ProfilesCreate_575076(name: "profilesCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}",
    validator: validate_ProfilesCreate_575077, base: "", url: url_ProfilesCreate_575078,
    schemes: {Scheme.Https})
type
  Call_ProfilesGet_575065 = ref object of OpenApiRestCall_574467
proc url_ProfilesGet_575067(protocol: Scheme; host: string; base: string;
                           route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesGet_575066(path: JsonNode; query: JsonNode; header: JsonNode;
                                formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a CDN profile with the specified profile name under the specified subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575068 = path.getOrDefault("resourceGroupName")
  valid_575068 = validateParameter(valid_575068, JString, required = true,
                                 default = nil)
  if valid_575068 != nil:
    section.add "resourceGroupName", valid_575068
  var valid_575069 = path.getOrDefault("subscriptionId")
  valid_575069 = validateParameter(valid_575069, JString, required = true,
                                 default = nil)
  if valid_575069 != nil:
    section.add "subscriptionId", valid_575069
  var valid_575070 = path.getOrDefault("profileName")
  valid_575070 = validateParameter(valid_575070, JString, required = true,
                                 default = nil)
  if valid_575070 != nil:
    section.add "profileName", valid_575070
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575071 = query.getOrDefault("api-version")
  valid_575071 = validateParameter(valid_575071, JString, required = true,
                                 default = nil)
  if valid_575071 != nil:
    section.add "api-version", valid_575071
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575072: Call_ProfilesGet_575065; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a CDN profile with the specified profile name under the specified subscription and resource group.
  ## 
  let valid = call_575072.validator(path, query, header, formData, body)
  let scheme = call_575072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575072.url(scheme.get, call_575072.host, call_575072.base,
                         call_575072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575072, url, valid)

proc call*(call_575073: Call_ProfilesGet_575065; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; profileName: string): Recallable =
  ## profilesGet
  ## Gets a CDN profile with the specified profile name under the specified subscription and resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  var path_575074 = newJObject()
  var query_575075 = newJObject()
  add(path_575074, "resourceGroupName", newJString(resourceGroupName))
  add(query_575075, "api-version", newJString(apiVersion))
  add(path_575074, "subscriptionId", newJString(subscriptionId))
  add(path_575074, "profileName", newJString(profileName))
  result = call_575073.call(path_575074, query_575075, nil, nil, nil)

var profilesGet* = Call_ProfilesGet_575065(name: "profilesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}",
                                        validator: validate_ProfilesGet_575066,
                                        base: "", url: url_ProfilesGet_575067,
                                        schemes: {Scheme.Https})
type
  Call_ProfilesUpdate_575100 = ref object of OpenApiRestCall_574467
proc url_ProfilesUpdate_575102(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesUpdate_575101(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Updates an existing CDN profile with the specified profile name under the specified subscription and resource group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575103 = path.getOrDefault("resourceGroupName")
  valid_575103 = validateParameter(valid_575103, JString, required = true,
                                 default = nil)
  if valid_575103 != nil:
    section.add "resourceGroupName", valid_575103
  var valid_575104 = path.getOrDefault("subscriptionId")
  valid_575104 = validateParameter(valid_575104, JString, required = true,
                                 default = nil)
  if valid_575104 != nil:
    section.add "subscriptionId", valid_575104
  var valid_575105 = path.getOrDefault("profileName")
  valid_575105 = validateParameter(valid_575105, JString, required = true,
                                 default = nil)
  if valid_575105 != nil:
    section.add "profileName", valid_575105
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575106 = query.getOrDefault("api-version")
  valid_575106 = validateParameter(valid_575106, JString, required = true,
                                 default = nil)
  if valid_575106 != nil:
    section.add "api-version", valid_575106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   profileUpdateParameters: JObject (required)
  ##                          : Profile properties needed to update an existing profile.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575108: Call_ProfilesUpdate_575100; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing CDN profile with the specified profile name under the specified subscription and resource group.
  ## 
  let valid = call_575108.validator(path, query, header, formData, body)
  let scheme = call_575108.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575108.url(scheme.get, call_575108.host, call_575108.base,
                         call_575108.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575108, url, valid)

proc call*(call_575109: Call_ProfilesUpdate_575100; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; profileName: string;
          profileUpdateParameters: JsonNode): Recallable =
  ## profilesUpdate
  ## Updates an existing CDN profile with the specified profile name under the specified subscription and resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   profileUpdateParameters: JObject (required)
  ##                          : Profile properties needed to update an existing profile.
  var path_575110 = newJObject()
  var query_575111 = newJObject()
  var body_575112 = newJObject()
  add(path_575110, "resourceGroupName", newJString(resourceGroupName))
  add(query_575111, "api-version", newJString(apiVersion))
  add(path_575110, "subscriptionId", newJString(subscriptionId))
  add(path_575110, "profileName", newJString(profileName))
  if profileUpdateParameters != nil:
    body_575112 = profileUpdateParameters
  result = call_575109.call(path_575110, query_575111, nil, nil, body_575112)

var profilesUpdate* = Call_ProfilesUpdate_575100(name: "profilesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}",
    validator: validate_ProfilesUpdate_575101, base: "", url: url_ProfilesUpdate_575102,
    schemes: {Scheme.Https})
type
  Call_ProfilesDelete_575089 = ref object of OpenApiRestCall_574467
proc url_ProfilesDelete_575091(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesDelete_575090(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Deletes an existing CDN profile with the specified parameters. Deleting a profile will result in the deletion of all of the sub-resources including endpoints, origins and custom domains.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575092 = path.getOrDefault("resourceGroupName")
  valid_575092 = validateParameter(valid_575092, JString, required = true,
                                 default = nil)
  if valid_575092 != nil:
    section.add "resourceGroupName", valid_575092
  var valid_575093 = path.getOrDefault("subscriptionId")
  valid_575093 = validateParameter(valid_575093, JString, required = true,
                                 default = nil)
  if valid_575093 != nil:
    section.add "subscriptionId", valid_575093
  var valid_575094 = path.getOrDefault("profileName")
  valid_575094 = validateParameter(valid_575094, JString, required = true,
                                 default = nil)
  if valid_575094 != nil:
    section.add "profileName", valid_575094
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575095 = query.getOrDefault("api-version")
  valid_575095 = validateParameter(valid_575095, JString, required = true,
                                 default = nil)
  if valid_575095 != nil:
    section.add "api-version", valid_575095
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575096: Call_ProfilesDelete_575089; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing CDN profile with the specified parameters. Deleting a profile will result in the deletion of all of the sub-resources including endpoints, origins and custom domains.
  ## 
  let valid = call_575096.validator(path, query, header, formData, body)
  let scheme = call_575096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575096.url(scheme.get, call_575096.host, call_575096.base,
                         call_575096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575096, url, valid)

proc call*(call_575097: Call_ProfilesDelete_575089; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; profileName: string): Recallable =
  ## profilesDelete
  ## Deletes an existing CDN profile with the specified parameters. Deleting a profile will result in the deletion of all of the sub-resources including endpoints, origins and custom domains.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  var path_575098 = newJObject()
  var query_575099 = newJObject()
  add(path_575098, "resourceGroupName", newJString(resourceGroupName))
  add(query_575099, "api-version", newJString(apiVersion))
  add(path_575098, "subscriptionId", newJString(subscriptionId))
  add(path_575098, "profileName", newJString(profileName))
  result = call_575097.call(path_575098, query_575099, nil, nil, nil)

var profilesDelete* = Call_ProfilesDelete_575089(name: "profilesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}",
    validator: validate_ProfilesDelete_575090, base: "", url: url_ProfilesDelete_575091,
    schemes: {Scheme.Https})
type
  Call_ProfilesListResourceUsage_575113 = ref object of OpenApiRestCall_574467
proc url_ProfilesListResourceUsage_575115(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/checkResourceUsage")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesListResourceUsage_575114(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks the quota and actual usage of endpoints under the given CDN profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575116 = path.getOrDefault("resourceGroupName")
  valid_575116 = validateParameter(valid_575116, JString, required = true,
                                 default = nil)
  if valid_575116 != nil:
    section.add "resourceGroupName", valid_575116
  var valid_575117 = path.getOrDefault("subscriptionId")
  valid_575117 = validateParameter(valid_575117, JString, required = true,
                                 default = nil)
  if valid_575117 != nil:
    section.add "subscriptionId", valid_575117
  var valid_575118 = path.getOrDefault("profileName")
  valid_575118 = validateParameter(valid_575118, JString, required = true,
                                 default = nil)
  if valid_575118 != nil:
    section.add "profileName", valid_575118
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575119 = query.getOrDefault("api-version")
  valid_575119 = validateParameter(valid_575119, JString, required = true,
                                 default = nil)
  if valid_575119 != nil:
    section.add "api-version", valid_575119
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575120: Call_ProfilesListResourceUsage_575113; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks the quota and actual usage of endpoints under the given CDN profile.
  ## 
  let valid = call_575120.validator(path, query, header, formData, body)
  let scheme = call_575120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575120.url(scheme.get, call_575120.host, call_575120.base,
                         call_575120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575120, url, valid)

proc call*(call_575121: Call_ProfilesListResourceUsage_575113;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          profileName: string): Recallable =
  ## profilesListResourceUsage
  ## Checks the quota and actual usage of endpoints under the given CDN profile.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  var path_575122 = newJObject()
  var query_575123 = newJObject()
  add(path_575122, "resourceGroupName", newJString(resourceGroupName))
  add(query_575123, "api-version", newJString(apiVersion))
  add(path_575122, "subscriptionId", newJString(subscriptionId))
  add(path_575122, "profileName", newJString(profileName))
  result = call_575121.call(path_575122, query_575123, nil, nil, nil)

var profilesListResourceUsage* = Call_ProfilesListResourceUsage_575113(
    name: "profilesListResourceUsage", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/checkResourceUsage",
    validator: validate_ProfilesListResourceUsage_575114, base: "",
    url: url_ProfilesListResourceUsage_575115, schemes: {Scheme.Https})
type
  Call_EndpointsListByProfile_575124 = ref object of OpenApiRestCall_574467
proc url_EndpointsListByProfile_575126(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsListByProfile_575125(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists existing CDN endpoints.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575127 = path.getOrDefault("resourceGroupName")
  valid_575127 = validateParameter(valid_575127, JString, required = true,
                                 default = nil)
  if valid_575127 != nil:
    section.add "resourceGroupName", valid_575127
  var valid_575128 = path.getOrDefault("subscriptionId")
  valid_575128 = validateParameter(valid_575128, JString, required = true,
                                 default = nil)
  if valid_575128 != nil:
    section.add "subscriptionId", valid_575128
  var valid_575129 = path.getOrDefault("profileName")
  valid_575129 = validateParameter(valid_575129, JString, required = true,
                                 default = nil)
  if valid_575129 != nil:
    section.add "profileName", valid_575129
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575130 = query.getOrDefault("api-version")
  valid_575130 = validateParameter(valid_575130, JString, required = true,
                                 default = nil)
  if valid_575130 != nil:
    section.add "api-version", valid_575130
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575131: Call_EndpointsListByProfile_575124; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists existing CDN endpoints.
  ## 
  let valid = call_575131.validator(path, query, header, formData, body)
  let scheme = call_575131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575131.url(scheme.get, call_575131.host, call_575131.base,
                         call_575131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575131, url, valid)

proc call*(call_575132: Call_EndpointsListByProfile_575124;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          profileName: string): Recallable =
  ## endpointsListByProfile
  ## Lists existing CDN endpoints.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  var path_575133 = newJObject()
  var query_575134 = newJObject()
  add(path_575133, "resourceGroupName", newJString(resourceGroupName))
  add(query_575134, "api-version", newJString(apiVersion))
  add(path_575133, "subscriptionId", newJString(subscriptionId))
  add(path_575133, "profileName", newJString(profileName))
  result = call_575132.call(path_575133, query_575134, nil, nil, nil)

var endpointsListByProfile* = Call_EndpointsListByProfile_575124(
    name: "endpointsListByProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints",
    validator: validate_EndpointsListByProfile_575125, base: "",
    url: url_EndpointsListByProfile_575126, schemes: {Scheme.Https})
type
  Call_EndpointsCreate_575147 = ref object of OpenApiRestCall_574467
proc url_EndpointsCreate_575149(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsCreate_575148(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Creates a new CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575150 = path.getOrDefault("resourceGroupName")
  valid_575150 = validateParameter(valid_575150, JString, required = true,
                                 default = nil)
  if valid_575150 != nil:
    section.add "resourceGroupName", valid_575150
  var valid_575151 = path.getOrDefault("subscriptionId")
  valid_575151 = validateParameter(valid_575151, JString, required = true,
                                 default = nil)
  if valid_575151 != nil:
    section.add "subscriptionId", valid_575151
  var valid_575152 = path.getOrDefault("profileName")
  valid_575152 = validateParameter(valid_575152, JString, required = true,
                                 default = nil)
  if valid_575152 != nil:
    section.add "profileName", valid_575152
  var valid_575153 = path.getOrDefault("endpointName")
  valid_575153 = validateParameter(valid_575153, JString, required = true,
                                 default = nil)
  if valid_575153 != nil:
    section.add "endpointName", valid_575153
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575154 = query.getOrDefault("api-version")
  valid_575154 = validateParameter(valid_575154, JString, required = true,
                                 default = nil)
  if valid_575154 != nil:
    section.add "api-version", valid_575154
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   endpoint: JObject (required)
  ##           : Endpoint properties
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575156: Call_EndpointsCreate_575147; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile.
  ## 
  let valid = call_575156.validator(path, query, header, formData, body)
  let scheme = call_575156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575156.url(scheme.get, call_575156.host, call_575156.base,
                         call_575156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575156, url, valid)

proc call*(call_575157: Call_EndpointsCreate_575147; resourceGroupName: string;
          apiVersion: string; endpoint: JsonNode; subscriptionId: string;
          profileName: string; endpointName: string): Recallable =
  ## endpointsCreate
  ## Creates a new CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   endpoint: JObject (required)
  ##           : Endpoint properties
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_575158 = newJObject()
  var query_575159 = newJObject()
  var body_575160 = newJObject()
  add(path_575158, "resourceGroupName", newJString(resourceGroupName))
  add(query_575159, "api-version", newJString(apiVersion))
  if endpoint != nil:
    body_575160 = endpoint
  add(path_575158, "subscriptionId", newJString(subscriptionId))
  add(path_575158, "profileName", newJString(profileName))
  add(path_575158, "endpointName", newJString(endpointName))
  result = call_575157.call(path_575158, query_575159, nil, nil, body_575160)

var endpointsCreate* = Call_EndpointsCreate_575147(name: "endpointsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}",
    validator: validate_EndpointsCreate_575148, base: "", url: url_EndpointsCreate_575149,
    schemes: {Scheme.Https})
type
  Call_EndpointsGet_575135 = ref object of OpenApiRestCall_574467
proc url_EndpointsGet_575137(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsGet_575136(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an existing CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575138 = path.getOrDefault("resourceGroupName")
  valid_575138 = validateParameter(valid_575138, JString, required = true,
                                 default = nil)
  if valid_575138 != nil:
    section.add "resourceGroupName", valid_575138
  var valid_575139 = path.getOrDefault("subscriptionId")
  valid_575139 = validateParameter(valid_575139, JString, required = true,
                                 default = nil)
  if valid_575139 != nil:
    section.add "subscriptionId", valid_575139
  var valid_575140 = path.getOrDefault("profileName")
  valid_575140 = validateParameter(valid_575140, JString, required = true,
                                 default = nil)
  if valid_575140 != nil:
    section.add "profileName", valid_575140
  var valid_575141 = path.getOrDefault("endpointName")
  valid_575141 = validateParameter(valid_575141, JString, required = true,
                                 default = nil)
  if valid_575141 != nil:
    section.add "endpointName", valid_575141
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575142 = query.getOrDefault("api-version")
  valid_575142 = validateParameter(valid_575142, JString, required = true,
                                 default = nil)
  if valid_575142 != nil:
    section.add "api-version", valid_575142
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575143: Call_EndpointsGet_575135; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an existing CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile.
  ## 
  let valid = call_575143.validator(path, query, header, formData, body)
  let scheme = call_575143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575143.url(scheme.get, call_575143.host, call_575143.base,
                         call_575143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575143, url, valid)

proc call*(call_575144: Call_EndpointsGet_575135; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; profileName: string;
          endpointName: string): Recallable =
  ## endpointsGet
  ## Gets an existing CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_575145 = newJObject()
  var query_575146 = newJObject()
  add(path_575145, "resourceGroupName", newJString(resourceGroupName))
  add(query_575146, "api-version", newJString(apiVersion))
  add(path_575145, "subscriptionId", newJString(subscriptionId))
  add(path_575145, "profileName", newJString(profileName))
  add(path_575145, "endpointName", newJString(endpointName))
  result = call_575144.call(path_575145, query_575146, nil, nil, nil)

var endpointsGet* = Call_EndpointsGet_575135(name: "endpointsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}",
    validator: validate_EndpointsGet_575136, base: "", url: url_EndpointsGet_575137,
    schemes: {Scheme.Https})
type
  Call_EndpointsUpdate_575173 = ref object of OpenApiRestCall_574467
proc url_EndpointsUpdate_575175(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsUpdate_575174(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Updates an existing CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile. Only tags and Origin HostHeader can be updated after creating an endpoint. To update origins, use the Update Origin operation. To update custom domains, use the Update Custom Domain operation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575176 = path.getOrDefault("resourceGroupName")
  valid_575176 = validateParameter(valid_575176, JString, required = true,
                                 default = nil)
  if valid_575176 != nil:
    section.add "resourceGroupName", valid_575176
  var valid_575177 = path.getOrDefault("subscriptionId")
  valid_575177 = validateParameter(valid_575177, JString, required = true,
                                 default = nil)
  if valid_575177 != nil:
    section.add "subscriptionId", valid_575177
  var valid_575178 = path.getOrDefault("profileName")
  valid_575178 = validateParameter(valid_575178, JString, required = true,
                                 default = nil)
  if valid_575178 != nil:
    section.add "profileName", valid_575178
  var valid_575179 = path.getOrDefault("endpointName")
  valid_575179 = validateParameter(valid_575179, JString, required = true,
                                 default = nil)
  if valid_575179 != nil:
    section.add "endpointName", valid_575179
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575180 = query.getOrDefault("api-version")
  valid_575180 = validateParameter(valid_575180, JString, required = true,
                                 default = nil)
  if valid_575180 != nil:
    section.add "api-version", valid_575180
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   endpointUpdateProperties: JObject (required)
  ##                           : Endpoint update properties
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575182: Call_EndpointsUpdate_575173; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile. Only tags and Origin HostHeader can be updated after creating an endpoint. To update origins, use the Update Origin operation. To update custom domains, use the Update Custom Domain operation.
  ## 
  let valid = call_575182.validator(path, query, header, formData, body)
  let scheme = call_575182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575182.url(scheme.get, call_575182.host, call_575182.base,
                         call_575182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575182, url, valid)

proc call*(call_575183: Call_EndpointsUpdate_575173; resourceGroupName: string;
          endpointUpdateProperties: JsonNode; apiVersion: string;
          subscriptionId: string; profileName: string; endpointName: string): Recallable =
  ## endpointsUpdate
  ## Updates an existing CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile. Only tags and Origin HostHeader can be updated after creating an endpoint. To update origins, use the Update Origin operation. To update custom domains, use the Update Custom Domain operation.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   endpointUpdateProperties: JObject (required)
  ##                           : Endpoint update properties
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_575184 = newJObject()
  var query_575185 = newJObject()
  var body_575186 = newJObject()
  add(path_575184, "resourceGroupName", newJString(resourceGroupName))
  if endpointUpdateProperties != nil:
    body_575186 = endpointUpdateProperties
  add(query_575185, "api-version", newJString(apiVersion))
  add(path_575184, "subscriptionId", newJString(subscriptionId))
  add(path_575184, "profileName", newJString(profileName))
  add(path_575184, "endpointName", newJString(endpointName))
  result = call_575183.call(path_575184, query_575185, nil, nil, body_575186)

var endpointsUpdate* = Call_EndpointsUpdate_575173(name: "endpointsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}",
    validator: validate_EndpointsUpdate_575174, base: "", url: url_EndpointsUpdate_575175,
    schemes: {Scheme.Https})
type
  Call_EndpointsDelete_575161 = ref object of OpenApiRestCall_574467
proc url_EndpointsDelete_575163(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsDelete_575162(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Deletes an existing CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575164 = path.getOrDefault("resourceGroupName")
  valid_575164 = validateParameter(valid_575164, JString, required = true,
                                 default = nil)
  if valid_575164 != nil:
    section.add "resourceGroupName", valid_575164
  var valid_575165 = path.getOrDefault("subscriptionId")
  valid_575165 = validateParameter(valid_575165, JString, required = true,
                                 default = nil)
  if valid_575165 != nil:
    section.add "subscriptionId", valid_575165
  var valid_575166 = path.getOrDefault("profileName")
  valid_575166 = validateParameter(valid_575166, JString, required = true,
                                 default = nil)
  if valid_575166 != nil:
    section.add "profileName", valid_575166
  var valid_575167 = path.getOrDefault("endpointName")
  valid_575167 = validateParameter(valid_575167, JString, required = true,
                                 default = nil)
  if valid_575167 != nil:
    section.add "endpointName", valid_575167
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575168 = query.getOrDefault("api-version")
  valid_575168 = validateParameter(valid_575168, JString, required = true,
                                 default = nil)
  if valid_575168 != nil:
    section.add "api-version", valid_575168
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575169: Call_EndpointsDelete_575161; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile.
  ## 
  let valid = call_575169.validator(path, query, header, formData, body)
  let scheme = call_575169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575169.url(scheme.get, call_575169.host, call_575169.base,
                         call_575169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575169, url, valid)

proc call*(call_575170: Call_EndpointsDelete_575161; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; profileName: string;
          endpointName: string): Recallable =
  ## endpointsDelete
  ## Deletes an existing CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_575171 = newJObject()
  var query_575172 = newJObject()
  add(path_575171, "resourceGroupName", newJString(resourceGroupName))
  add(query_575172, "api-version", newJString(apiVersion))
  add(path_575171, "subscriptionId", newJString(subscriptionId))
  add(path_575171, "profileName", newJString(profileName))
  add(path_575171, "endpointName", newJString(endpointName))
  result = call_575170.call(path_575171, query_575172, nil, nil, nil)

var endpointsDelete* = Call_EndpointsDelete_575161(name: "endpointsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}",
    validator: validate_EndpointsDelete_575162, base: "", url: url_EndpointsDelete_575163,
    schemes: {Scheme.Https})
type
  Call_EndpointsListResourceUsage_575187 = ref object of OpenApiRestCall_574467
proc url_EndpointsListResourceUsage_575189(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/checkResourceUsage")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsListResourceUsage_575188(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks the quota and usage of geo filters and custom domains under the given endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575190 = path.getOrDefault("resourceGroupName")
  valid_575190 = validateParameter(valid_575190, JString, required = true,
                                 default = nil)
  if valid_575190 != nil:
    section.add "resourceGroupName", valid_575190
  var valid_575191 = path.getOrDefault("subscriptionId")
  valid_575191 = validateParameter(valid_575191, JString, required = true,
                                 default = nil)
  if valid_575191 != nil:
    section.add "subscriptionId", valid_575191
  var valid_575192 = path.getOrDefault("profileName")
  valid_575192 = validateParameter(valid_575192, JString, required = true,
                                 default = nil)
  if valid_575192 != nil:
    section.add "profileName", valid_575192
  var valid_575193 = path.getOrDefault("endpointName")
  valid_575193 = validateParameter(valid_575193, JString, required = true,
                                 default = nil)
  if valid_575193 != nil:
    section.add "endpointName", valid_575193
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575194 = query.getOrDefault("api-version")
  valid_575194 = validateParameter(valid_575194, JString, required = true,
                                 default = nil)
  if valid_575194 != nil:
    section.add "api-version", valid_575194
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575195: Call_EndpointsListResourceUsage_575187; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks the quota and usage of geo filters and custom domains under the given endpoint.
  ## 
  let valid = call_575195.validator(path, query, header, formData, body)
  let scheme = call_575195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575195.url(scheme.get, call_575195.host, call_575195.base,
                         call_575195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575195, url, valid)

proc call*(call_575196: Call_EndpointsListResourceUsage_575187;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          profileName: string; endpointName: string): Recallable =
  ## endpointsListResourceUsage
  ## Checks the quota and usage of geo filters and custom domains under the given endpoint.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_575197 = newJObject()
  var query_575198 = newJObject()
  add(path_575197, "resourceGroupName", newJString(resourceGroupName))
  add(query_575198, "api-version", newJString(apiVersion))
  add(path_575197, "subscriptionId", newJString(subscriptionId))
  add(path_575197, "profileName", newJString(profileName))
  add(path_575197, "endpointName", newJString(endpointName))
  result = call_575196.call(path_575197, query_575198, nil, nil, nil)

var endpointsListResourceUsage* = Call_EndpointsListResourceUsage_575187(
    name: "endpointsListResourceUsage", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/checkResourceUsage",
    validator: validate_EndpointsListResourceUsage_575188, base: "",
    url: url_EndpointsListResourceUsage_575189, schemes: {Scheme.Https})
type
  Call_CustomDomainsListByEndpoint_575199 = ref object of OpenApiRestCall_574467
proc url_CustomDomainsListByEndpoint_575201(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/customDomains")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomDomainsListByEndpoint_575200(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the existing custom domains within an endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575202 = path.getOrDefault("resourceGroupName")
  valid_575202 = validateParameter(valid_575202, JString, required = true,
                                 default = nil)
  if valid_575202 != nil:
    section.add "resourceGroupName", valid_575202
  var valid_575203 = path.getOrDefault("subscriptionId")
  valid_575203 = validateParameter(valid_575203, JString, required = true,
                                 default = nil)
  if valid_575203 != nil:
    section.add "subscriptionId", valid_575203
  var valid_575204 = path.getOrDefault("profileName")
  valid_575204 = validateParameter(valid_575204, JString, required = true,
                                 default = nil)
  if valid_575204 != nil:
    section.add "profileName", valid_575204
  var valid_575205 = path.getOrDefault("endpointName")
  valid_575205 = validateParameter(valid_575205, JString, required = true,
                                 default = nil)
  if valid_575205 != nil:
    section.add "endpointName", valid_575205
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575206 = query.getOrDefault("api-version")
  valid_575206 = validateParameter(valid_575206, JString, required = true,
                                 default = nil)
  if valid_575206 != nil:
    section.add "api-version", valid_575206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575207: Call_CustomDomainsListByEndpoint_575199; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the existing custom domains within an endpoint.
  ## 
  let valid = call_575207.validator(path, query, header, formData, body)
  let scheme = call_575207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575207.url(scheme.get, call_575207.host, call_575207.base,
                         call_575207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575207, url, valid)

proc call*(call_575208: Call_CustomDomainsListByEndpoint_575199;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          profileName: string; endpointName: string): Recallable =
  ## customDomainsListByEndpoint
  ## Lists all of the existing custom domains within an endpoint.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_575209 = newJObject()
  var query_575210 = newJObject()
  add(path_575209, "resourceGroupName", newJString(resourceGroupName))
  add(query_575210, "api-version", newJString(apiVersion))
  add(path_575209, "subscriptionId", newJString(subscriptionId))
  add(path_575209, "profileName", newJString(profileName))
  add(path_575209, "endpointName", newJString(endpointName))
  result = call_575208.call(path_575209, query_575210, nil, nil, nil)

var customDomainsListByEndpoint* = Call_CustomDomainsListByEndpoint_575199(
    name: "customDomainsListByEndpoint", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/customDomains",
    validator: validate_CustomDomainsListByEndpoint_575200, base: "",
    url: url_CustomDomainsListByEndpoint_575201, schemes: {Scheme.Https})
type
  Call_CustomDomainsCreate_575224 = ref object of OpenApiRestCall_574467
proc url_CustomDomainsCreate_575226(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  assert "customDomainName" in path,
        "`customDomainName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/customDomains/"),
               (kind: VariableSegment, value: "customDomainName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomDomainsCreate_575225(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Creates a new custom domain within an endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   customDomainName: JString (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575227 = path.getOrDefault("resourceGroupName")
  valid_575227 = validateParameter(valid_575227, JString, required = true,
                                 default = nil)
  if valid_575227 != nil:
    section.add "resourceGroupName", valid_575227
  var valid_575228 = path.getOrDefault("subscriptionId")
  valid_575228 = validateParameter(valid_575228, JString, required = true,
                                 default = nil)
  if valid_575228 != nil:
    section.add "subscriptionId", valid_575228
  var valid_575229 = path.getOrDefault("customDomainName")
  valid_575229 = validateParameter(valid_575229, JString, required = true,
                                 default = nil)
  if valid_575229 != nil:
    section.add "customDomainName", valid_575229
  var valid_575230 = path.getOrDefault("profileName")
  valid_575230 = validateParameter(valid_575230, JString, required = true,
                                 default = nil)
  if valid_575230 != nil:
    section.add "profileName", valid_575230
  var valid_575231 = path.getOrDefault("endpointName")
  valid_575231 = validateParameter(valid_575231, JString, required = true,
                                 default = nil)
  if valid_575231 != nil:
    section.add "endpointName", valid_575231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575232 = query.getOrDefault("api-version")
  valid_575232 = validateParameter(valid_575232, JString, required = true,
                                 default = nil)
  if valid_575232 != nil:
    section.add "api-version", valid_575232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   customDomainProperties: JObject (required)
  ##                         : Properties required to create a new custom domain.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575234: Call_CustomDomainsCreate_575224; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new custom domain within an endpoint.
  ## 
  let valid = call_575234.validator(path, query, header, formData, body)
  let scheme = call_575234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575234.url(scheme.get, call_575234.host, call_575234.base,
                         call_575234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575234, url, valid)

proc call*(call_575235: Call_CustomDomainsCreate_575224; resourceGroupName: string;
          apiVersion: string; customDomainProperties: JsonNode;
          subscriptionId: string; customDomainName: string; profileName: string;
          endpointName: string): Recallable =
  ## customDomainsCreate
  ## Creates a new custom domain within an endpoint.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   customDomainProperties: JObject (required)
  ##                         : Properties required to create a new custom domain.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   customDomainName: string (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_575236 = newJObject()
  var query_575237 = newJObject()
  var body_575238 = newJObject()
  add(path_575236, "resourceGroupName", newJString(resourceGroupName))
  add(query_575237, "api-version", newJString(apiVersion))
  if customDomainProperties != nil:
    body_575238 = customDomainProperties
  add(path_575236, "subscriptionId", newJString(subscriptionId))
  add(path_575236, "customDomainName", newJString(customDomainName))
  add(path_575236, "profileName", newJString(profileName))
  add(path_575236, "endpointName", newJString(endpointName))
  result = call_575235.call(path_575236, query_575237, nil, nil, body_575238)

var customDomainsCreate* = Call_CustomDomainsCreate_575224(
    name: "customDomainsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/customDomains/{customDomainName}",
    validator: validate_CustomDomainsCreate_575225, base: "",
    url: url_CustomDomainsCreate_575226, schemes: {Scheme.Https})
type
  Call_CustomDomainsGet_575211 = ref object of OpenApiRestCall_574467
proc url_CustomDomainsGet_575213(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  assert "customDomainName" in path,
        "`customDomainName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/customDomains/"),
               (kind: VariableSegment, value: "customDomainName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomDomainsGet_575212(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets an existing custom domain within an endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   customDomainName: JString (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575214 = path.getOrDefault("resourceGroupName")
  valid_575214 = validateParameter(valid_575214, JString, required = true,
                                 default = nil)
  if valid_575214 != nil:
    section.add "resourceGroupName", valid_575214
  var valid_575215 = path.getOrDefault("subscriptionId")
  valid_575215 = validateParameter(valid_575215, JString, required = true,
                                 default = nil)
  if valid_575215 != nil:
    section.add "subscriptionId", valid_575215
  var valid_575216 = path.getOrDefault("customDomainName")
  valid_575216 = validateParameter(valid_575216, JString, required = true,
                                 default = nil)
  if valid_575216 != nil:
    section.add "customDomainName", valid_575216
  var valid_575217 = path.getOrDefault("profileName")
  valid_575217 = validateParameter(valid_575217, JString, required = true,
                                 default = nil)
  if valid_575217 != nil:
    section.add "profileName", valid_575217
  var valid_575218 = path.getOrDefault("endpointName")
  valid_575218 = validateParameter(valid_575218, JString, required = true,
                                 default = nil)
  if valid_575218 != nil:
    section.add "endpointName", valid_575218
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575219 = query.getOrDefault("api-version")
  valid_575219 = validateParameter(valid_575219, JString, required = true,
                                 default = nil)
  if valid_575219 != nil:
    section.add "api-version", valid_575219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575220: Call_CustomDomainsGet_575211; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an existing custom domain within an endpoint.
  ## 
  let valid = call_575220.validator(path, query, header, formData, body)
  let scheme = call_575220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575220.url(scheme.get, call_575220.host, call_575220.base,
                         call_575220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575220, url, valid)

proc call*(call_575221: Call_CustomDomainsGet_575211; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; customDomainName: string;
          profileName: string; endpointName: string): Recallable =
  ## customDomainsGet
  ## Gets an existing custom domain within an endpoint.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   customDomainName: string (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_575222 = newJObject()
  var query_575223 = newJObject()
  add(path_575222, "resourceGroupName", newJString(resourceGroupName))
  add(query_575223, "api-version", newJString(apiVersion))
  add(path_575222, "subscriptionId", newJString(subscriptionId))
  add(path_575222, "customDomainName", newJString(customDomainName))
  add(path_575222, "profileName", newJString(profileName))
  add(path_575222, "endpointName", newJString(endpointName))
  result = call_575221.call(path_575222, query_575223, nil, nil, nil)

var customDomainsGet* = Call_CustomDomainsGet_575211(name: "customDomainsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/customDomains/{customDomainName}",
    validator: validate_CustomDomainsGet_575212, base: "",
    url: url_CustomDomainsGet_575213, schemes: {Scheme.Https})
type
  Call_CustomDomainsDelete_575239 = ref object of OpenApiRestCall_574467
proc url_CustomDomainsDelete_575241(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  assert "customDomainName" in path,
        "`customDomainName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/customDomains/"),
               (kind: VariableSegment, value: "customDomainName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomDomainsDelete_575240(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Deletes an existing custom domain within an endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   customDomainName: JString (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575242 = path.getOrDefault("resourceGroupName")
  valid_575242 = validateParameter(valid_575242, JString, required = true,
                                 default = nil)
  if valid_575242 != nil:
    section.add "resourceGroupName", valid_575242
  var valid_575243 = path.getOrDefault("subscriptionId")
  valid_575243 = validateParameter(valid_575243, JString, required = true,
                                 default = nil)
  if valid_575243 != nil:
    section.add "subscriptionId", valid_575243
  var valid_575244 = path.getOrDefault("customDomainName")
  valid_575244 = validateParameter(valid_575244, JString, required = true,
                                 default = nil)
  if valid_575244 != nil:
    section.add "customDomainName", valid_575244
  var valid_575245 = path.getOrDefault("profileName")
  valid_575245 = validateParameter(valid_575245, JString, required = true,
                                 default = nil)
  if valid_575245 != nil:
    section.add "profileName", valid_575245
  var valid_575246 = path.getOrDefault("endpointName")
  valid_575246 = validateParameter(valid_575246, JString, required = true,
                                 default = nil)
  if valid_575246 != nil:
    section.add "endpointName", valid_575246
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575247 = query.getOrDefault("api-version")
  valid_575247 = validateParameter(valid_575247, JString, required = true,
                                 default = nil)
  if valid_575247 != nil:
    section.add "api-version", valid_575247
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575248: Call_CustomDomainsDelete_575239; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing custom domain within an endpoint.
  ## 
  let valid = call_575248.validator(path, query, header, formData, body)
  let scheme = call_575248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575248.url(scheme.get, call_575248.host, call_575248.base,
                         call_575248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575248, url, valid)

proc call*(call_575249: Call_CustomDomainsDelete_575239; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; customDomainName: string;
          profileName: string; endpointName: string): Recallable =
  ## customDomainsDelete
  ## Deletes an existing custom domain within an endpoint.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   customDomainName: string (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_575250 = newJObject()
  var query_575251 = newJObject()
  add(path_575250, "resourceGroupName", newJString(resourceGroupName))
  add(query_575251, "api-version", newJString(apiVersion))
  add(path_575250, "subscriptionId", newJString(subscriptionId))
  add(path_575250, "customDomainName", newJString(customDomainName))
  add(path_575250, "profileName", newJString(profileName))
  add(path_575250, "endpointName", newJString(endpointName))
  result = call_575249.call(path_575250, query_575251, nil, nil, nil)

var customDomainsDelete* = Call_CustomDomainsDelete_575239(
    name: "customDomainsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/customDomains/{customDomainName}",
    validator: validate_CustomDomainsDelete_575240, base: "",
    url: url_CustomDomainsDelete_575241, schemes: {Scheme.Https})
type
  Call_CustomDomainsDisableCustomHttps_575252 = ref object of OpenApiRestCall_574467
proc url_CustomDomainsDisableCustomHttps_575254(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  assert "customDomainName" in path,
        "`customDomainName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/customDomains/"),
               (kind: VariableSegment, value: "customDomainName"),
               (kind: ConstantSegment, value: "/disableCustomHttps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomDomainsDisableCustomHttps_575253(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Disable https delivery of the custom domain.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   customDomainName: JString (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575255 = path.getOrDefault("resourceGroupName")
  valid_575255 = validateParameter(valid_575255, JString, required = true,
                                 default = nil)
  if valid_575255 != nil:
    section.add "resourceGroupName", valid_575255
  var valid_575256 = path.getOrDefault("subscriptionId")
  valid_575256 = validateParameter(valid_575256, JString, required = true,
                                 default = nil)
  if valid_575256 != nil:
    section.add "subscriptionId", valid_575256
  var valid_575257 = path.getOrDefault("customDomainName")
  valid_575257 = validateParameter(valid_575257, JString, required = true,
                                 default = nil)
  if valid_575257 != nil:
    section.add "customDomainName", valid_575257
  var valid_575258 = path.getOrDefault("profileName")
  valid_575258 = validateParameter(valid_575258, JString, required = true,
                                 default = nil)
  if valid_575258 != nil:
    section.add "profileName", valid_575258
  var valid_575259 = path.getOrDefault("endpointName")
  valid_575259 = validateParameter(valid_575259, JString, required = true,
                                 default = nil)
  if valid_575259 != nil:
    section.add "endpointName", valid_575259
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575260 = query.getOrDefault("api-version")
  valid_575260 = validateParameter(valid_575260, JString, required = true,
                                 default = nil)
  if valid_575260 != nil:
    section.add "api-version", valid_575260
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575261: Call_CustomDomainsDisableCustomHttps_575252;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Disable https delivery of the custom domain.
  ## 
  let valid = call_575261.validator(path, query, header, formData, body)
  let scheme = call_575261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575261.url(scheme.get, call_575261.host, call_575261.base,
                         call_575261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575261, url, valid)

proc call*(call_575262: Call_CustomDomainsDisableCustomHttps_575252;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          customDomainName: string; profileName: string; endpointName: string): Recallable =
  ## customDomainsDisableCustomHttps
  ## Disable https delivery of the custom domain.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   customDomainName: string (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_575263 = newJObject()
  var query_575264 = newJObject()
  add(path_575263, "resourceGroupName", newJString(resourceGroupName))
  add(query_575264, "api-version", newJString(apiVersion))
  add(path_575263, "subscriptionId", newJString(subscriptionId))
  add(path_575263, "customDomainName", newJString(customDomainName))
  add(path_575263, "profileName", newJString(profileName))
  add(path_575263, "endpointName", newJString(endpointName))
  result = call_575262.call(path_575263, query_575264, nil, nil, nil)

var customDomainsDisableCustomHttps* = Call_CustomDomainsDisableCustomHttps_575252(
    name: "customDomainsDisableCustomHttps", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/customDomains/{customDomainName}/disableCustomHttps",
    validator: validate_CustomDomainsDisableCustomHttps_575253, base: "",
    url: url_CustomDomainsDisableCustomHttps_575254, schemes: {Scheme.Https})
type
  Call_CustomDomainsEnableCustomHttps_575265 = ref object of OpenApiRestCall_574467
proc url_CustomDomainsEnableCustomHttps_575267(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  assert "customDomainName" in path,
        "`customDomainName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/customDomains/"),
               (kind: VariableSegment, value: "customDomainName"),
               (kind: ConstantSegment, value: "/enableCustomHttps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CustomDomainsEnableCustomHttps_575266(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Enable https delivery of the custom domain.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   customDomainName: JString (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575285 = path.getOrDefault("resourceGroupName")
  valid_575285 = validateParameter(valid_575285, JString, required = true,
                                 default = nil)
  if valid_575285 != nil:
    section.add "resourceGroupName", valid_575285
  var valid_575286 = path.getOrDefault("subscriptionId")
  valid_575286 = validateParameter(valid_575286, JString, required = true,
                                 default = nil)
  if valid_575286 != nil:
    section.add "subscriptionId", valid_575286
  var valid_575287 = path.getOrDefault("customDomainName")
  valid_575287 = validateParameter(valid_575287, JString, required = true,
                                 default = nil)
  if valid_575287 != nil:
    section.add "customDomainName", valid_575287
  var valid_575288 = path.getOrDefault("profileName")
  valid_575288 = validateParameter(valid_575288, JString, required = true,
                                 default = nil)
  if valid_575288 != nil:
    section.add "profileName", valid_575288
  var valid_575289 = path.getOrDefault("endpointName")
  valid_575289 = validateParameter(valid_575289, JString, required = true,
                                 default = nil)
  if valid_575289 != nil:
    section.add "endpointName", valid_575289
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575290 = query.getOrDefault("api-version")
  valid_575290 = validateParameter(valid_575290, JString, required = true,
                                 default = nil)
  if valid_575290 != nil:
    section.add "api-version", valid_575290
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   customDomainHttpsParameters: JObject
  ##                              : The configuration specifying how to enable HTTPS for the custom domain - using CDN managed certificate or user's own certificate. If not specified, enabling ssl uses CDN managed certificate by default.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575292: Call_CustomDomainsEnableCustomHttps_575265; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enable https delivery of the custom domain.
  ## 
  let valid = call_575292.validator(path, query, header, formData, body)
  let scheme = call_575292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575292.url(scheme.get, call_575292.host, call_575292.base,
                         call_575292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575292, url, valid)

proc call*(call_575293: Call_CustomDomainsEnableCustomHttps_575265;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          customDomainName: string; profileName: string; endpointName: string;
          customDomainHttpsParameters: JsonNode = nil): Recallable =
  ## customDomainsEnableCustomHttps
  ## Enable https delivery of the custom domain.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   customDomainName: string (required)
  ##                   : Name of the custom domain within an endpoint.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   customDomainHttpsParameters: JObject
  ##                              : The configuration specifying how to enable HTTPS for the custom domain - using CDN managed certificate or user's own certificate. If not specified, enabling ssl uses CDN managed certificate by default.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_575294 = newJObject()
  var query_575295 = newJObject()
  var body_575296 = newJObject()
  add(path_575294, "resourceGroupName", newJString(resourceGroupName))
  add(query_575295, "api-version", newJString(apiVersion))
  add(path_575294, "subscriptionId", newJString(subscriptionId))
  add(path_575294, "customDomainName", newJString(customDomainName))
  add(path_575294, "profileName", newJString(profileName))
  if customDomainHttpsParameters != nil:
    body_575296 = customDomainHttpsParameters
  add(path_575294, "endpointName", newJString(endpointName))
  result = call_575293.call(path_575294, query_575295, nil, nil, body_575296)

var customDomainsEnableCustomHttps* = Call_CustomDomainsEnableCustomHttps_575265(
    name: "customDomainsEnableCustomHttps", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/customDomains/{customDomainName}/enableCustomHttps",
    validator: validate_CustomDomainsEnableCustomHttps_575266, base: "",
    url: url_CustomDomainsEnableCustomHttps_575267, schemes: {Scheme.Https})
type
  Call_EndpointsLoadContent_575297 = ref object of OpenApiRestCall_574467
proc url_EndpointsLoadContent_575299(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/load")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsLoadContent_575298(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Pre-loads a content to CDN. Available for Verizon Profiles.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575300 = path.getOrDefault("resourceGroupName")
  valid_575300 = validateParameter(valid_575300, JString, required = true,
                                 default = nil)
  if valid_575300 != nil:
    section.add "resourceGroupName", valid_575300
  var valid_575301 = path.getOrDefault("subscriptionId")
  valid_575301 = validateParameter(valid_575301, JString, required = true,
                                 default = nil)
  if valid_575301 != nil:
    section.add "subscriptionId", valid_575301
  var valid_575302 = path.getOrDefault("profileName")
  valid_575302 = validateParameter(valid_575302, JString, required = true,
                                 default = nil)
  if valid_575302 != nil:
    section.add "profileName", valid_575302
  var valid_575303 = path.getOrDefault("endpointName")
  valid_575303 = validateParameter(valid_575303, JString, required = true,
                                 default = nil)
  if valid_575303 != nil:
    section.add "endpointName", valid_575303
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575304 = query.getOrDefault("api-version")
  valid_575304 = validateParameter(valid_575304, JString, required = true,
                                 default = nil)
  if valid_575304 != nil:
    section.add "api-version", valid_575304
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   contentFilePaths: JObject (required)
  ##                   : The path to the content to be loaded. Path should be a full URL, e.g. ‘/pictures/city.png' which loads a single file 
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575306: Call_EndpointsLoadContent_575297; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Pre-loads a content to CDN. Available for Verizon Profiles.
  ## 
  let valid = call_575306.validator(path, query, header, formData, body)
  let scheme = call_575306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575306.url(scheme.get, call_575306.host, call_575306.base,
                         call_575306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575306, url, valid)

proc call*(call_575307: Call_EndpointsLoadContent_575297;
          resourceGroupName: string; contentFilePaths: JsonNode; apiVersion: string;
          subscriptionId: string; profileName: string; endpointName: string): Recallable =
  ## endpointsLoadContent
  ## Pre-loads a content to CDN. Available for Verizon Profiles.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   contentFilePaths: JObject (required)
  ##                   : The path to the content to be loaded. Path should be a full URL, e.g. ‘/pictures/city.png' which loads a single file 
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_575308 = newJObject()
  var query_575309 = newJObject()
  var body_575310 = newJObject()
  add(path_575308, "resourceGroupName", newJString(resourceGroupName))
  if contentFilePaths != nil:
    body_575310 = contentFilePaths
  add(query_575309, "api-version", newJString(apiVersion))
  add(path_575308, "subscriptionId", newJString(subscriptionId))
  add(path_575308, "profileName", newJString(profileName))
  add(path_575308, "endpointName", newJString(endpointName))
  result = call_575307.call(path_575308, query_575309, nil, nil, body_575310)

var endpointsLoadContent* = Call_EndpointsLoadContent_575297(
    name: "endpointsLoadContent", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/load",
    validator: validate_EndpointsLoadContent_575298, base: "",
    url: url_EndpointsLoadContent_575299, schemes: {Scheme.Https})
type
  Call_OriginsListByEndpoint_575311 = ref object of OpenApiRestCall_574467
proc url_OriginsListByEndpoint_575313(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/origins")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OriginsListByEndpoint_575312(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the existing origins within an endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575314 = path.getOrDefault("resourceGroupName")
  valid_575314 = validateParameter(valid_575314, JString, required = true,
                                 default = nil)
  if valid_575314 != nil:
    section.add "resourceGroupName", valid_575314
  var valid_575315 = path.getOrDefault("subscriptionId")
  valid_575315 = validateParameter(valid_575315, JString, required = true,
                                 default = nil)
  if valid_575315 != nil:
    section.add "subscriptionId", valid_575315
  var valid_575316 = path.getOrDefault("profileName")
  valid_575316 = validateParameter(valid_575316, JString, required = true,
                                 default = nil)
  if valid_575316 != nil:
    section.add "profileName", valid_575316
  var valid_575317 = path.getOrDefault("endpointName")
  valid_575317 = validateParameter(valid_575317, JString, required = true,
                                 default = nil)
  if valid_575317 != nil:
    section.add "endpointName", valid_575317
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575318 = query.getOrDefault("api-version")
  valid_575318 = validateParameter(valid_575318, JString, required = true,
                                 default = nil)
  if valid_575318 != nil:
    section.add "api-version", valid_575318
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575319: Call_OriginsListByEndpoint_575311; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the existing origins within an endpoint.
  ## 
  let valid = call_575319.validator(path, query, header, formData, body)
  let scheme = call_575319.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575319.url(scheme.get, call_575319.host, call_575319.base,
                         call_575319.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575319, url, valid)

proc call*(call_575320: Call_OriginsListByEndpoint_575311;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          profileName: string; endpointName: string): Recallable =
  ## originsListByEndpoint
  ## Lists all of the existing origins within an endpoint.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_575321 = newJObject()
  var query_575322 = newJObject()
  add(path_575321, "resourceGroupName", newJString(resourceGroupName))
  add(query_575322, "api-version", newJString(apiVersion))
  add(path_575321, "subscriptionId", newJString(subscriptionId))
  add(path_575321, "profileName", newJString(profileName))
  add(path_575321, "endpointName", newJString(endpointName))
  result = call_575320.call(path_575321, query_575322, nil, nil, nil)

var originsListByEndpoint* = Call_OriginsListByEndpoint_575311(
    name: "originsListByEndpoint", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/origins",
    validator: validate_OriginsListByEndpoint_575312, base: "",
    url: url_OriginsListByEndpoint_575313, schemes: {Scheme.Https})
type
  Call_OriginsGet_575323 = ref object of OpenApiRestCall_574467
proc url_OriginsGet_575325(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  assert "originName" in path, "`originName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/origins/"),
               (kind: VariableSegment, value: "originName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OriginsGet_575324(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an existing origin within an endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   originName: JString (required)
  ##             : Name of the origin which is unique within the endpoint.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575326 = path.getOrDefault("resourceGroupName")
  valid_575326 = validateParameter(valid_575326, JString, required = true,
                                 default = nil)
  if valid_575326 != nil:
    section.add "resourceGroupName", valid_575326
  var valid_575327 = path.getOrDefault("originName")
  valid_575327 = validateParameter(valid_575327, JString, required = true,
                                 default = nil)
  if valid_575327 != nil:
    section.add "originName", valid_575327
  var valid_575328 = path.getOrDefault("subscriptionId")
  valid_575328 = validateParameter(valid_575328, JString, required = true,
                                 default = nil)
  if valid_575328 != nil:
    section.add "subscriptionId", valid_575328
  var valid_575329 = path.getOrDefault("profileName")
  valid_575329 = validateParameter(valid_575329, JString, required = true,
                                 default = nil)
  if valid_575329 != nil:
    section.add "profileName", valid_575329
  var valid_575330 = path.getOrDefault("endpointName")
  valid_575330 = validateParameter(valid_575330, JString, required = true,
                                 default = nil)
  if valid_575330 != nil:
    section.add "endpointName", valid_575330
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575331 = query.getOrDefault("api-version")
  valid_575331 = validateParameter(valid_575331, JString, required = true,
                                 default = nil)
  if valid_575331 != nil:
    section.add "api-version", valid_575331
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575332: Call_OriginsGet_575323; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an existing origin within an endpoint.
  ## 
  let valid = call_575332.validator(path, query, header, formData, body)
  let scheme = call_575332.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575332.url(scheme.get, call_575332.host, call_575332.base,
                         call_575332.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575332, url, valid)

proc call*(call_575333: Call_OriginsGet_575323; resourceGroupName: string;
          apiVersion: string; originName: string; subscriptionId: string;
          profileName: string; endpointName: string): Recallable =
  ## originsGet
  ## Gets an existing origin within an endpoint.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   originName: string (required)
  ##             : Name of the origin which is unique within the endpoint.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_575334 = newJObject()
  var query_575335 = newJObject()
  add(path_575334, "resourceGroupName", newJString(resourceGroupName))
  add(query_575335, "api-version", newJString(apiVersion))
  add(path_575334, "originName", newJString(originName))
  add(path_575334, "subscriptionId", newJString(subscriptionId))
  add(path_575334, "profileName", newJString(profileName))
  add(path_575334, "endpointName", newJString(endpointName))
  result = call_575333.call(path_575334, query_575335, nil, nil, nil)

var originsGet* = Call_OriginsGet_575323(name: "originsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/origins/{originName}",
                                      validator: validate_OriginsGet_575324,
                                      base: "", url: url_OriginsGet_575325,
                                      schemes: {Scheme.Https})
type
  Call_OriginsUpdate_575336 = ref object of OpenApiRestCall_574467
proc url_OriginsUpdate_575338(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  assert "originName" in path, "`originName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/origins/"),
               (kind: VariableSegment, value: "originName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_OriginsUpdate_575337(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing origin within an endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   originName: JString (required)
  ##             : Name of the origin which is unique within the endpoint.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575339 = path.getOrDefault("resourceGroupName")
  valid_575339 = validateParameter(valid_575339, JString, required = true,
                                 default = nil)
  if valid_575339 != nil:
    section.add "resourceGroupName", valid_575339
  var valid_575340 = path.getOrDefault("originName")
  valid_575340 = validateParameter(valid_575340, JString, required = true,
                                 default = nil)
  if valid_575340 != nil:
    section.add "originName", valid_575340
  var valid_575341 = path.getOrDefault("subscriptionId")
  valid_575341 = validateParameter(valid_575341, JString, required = true,
                                 default = nil)
  if valid_575341 != nil:
    section.add "subscriptionId", valid_575341
  var valid_575342 = path.getOrDefault("profileName")
  valid_575342 = validateParameter(valid_575342, JString, required = true,
                                 default = nil)
  if valid_575342 != nil:
    section.add "profileName", valid_575342
  var valid_575343 = path.getOrDefault("endpointName")
  valid_575343 = validateParameter(valid_575343, JString, required = true,
                                 default = nil)
  if valid_575343 != nil:
    section.add "endpointName", valid_575343
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575344 = query.getOrDefault("api-version")
  valid_575344 = validateParameter(valid_575344, JString, required = true,
                                 default = nil)
  if valid_575344 != nil:
    section.add "api-version", valid_575344
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   originUpdateProperties: JObject (required)
  ##                         : Origin properties
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575346: Call_OriginsUpdate_575336; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing origin within an endpoint.
  ## 
  let valid = call_575346.validator(path, query, header, formData, body)
  let scheme = call_575346.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575346.url(scheme.get, call_575346.host, call_575346.base,
                         call_575346.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575346, url, valid)

proc call*(call_575347: Call_OriginsUpdate_575336;
          originUpdateProperties: JsonNode; resourceGroupName: string;
          apiVersion: string; originName: string; subscriptionId: string;
          profileName: string; endpointName: string): Recallable =
  ## originsUpdate
  ## Updates an existing origin within an endpoint.
  ##   originUpdateProperties: JObject (required)
  ##                         : Origin properties
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   originName: string (required)
  ##             : Name of the origin which is unique within the endpoint.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_575348 = newJObject()
  var query_575349 = newJObject()
  var body_575350 = newJObject()
  if originUpdateProperties != nil:
    body_575350 = originUpdateProperties
  add(path_575348, "resourceGroupName", newJString(resourceGroupName))
  add(query_575349, "api-version", newJString(apiVersion))
  add(path_575348, "originName", newJString(originName))
  add(path_575348, "subscriptionId", newJString(subscriptionId))
  add(path_575348, "profileName", newJString(profileName))
  add(path_575348, "endpointName", newJString(endpointName))
  result = call_575347.call(path_575348, query_575349, nil, nil, body_575350)

var originsUpdate* = Call_OriginsUpdate_575336(name: "originsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/origins/{originName}",
    validator: validate_OriginsUpdate_575337, base: "", url: url_OriginsUpdate_575338,
    schemes: {Scheme.Https})
type
  Call_EndpointsPurgeContent_575351 = ref object of OpenApiRestCall_574467
proc url_EndpointsPurgeContent_575353(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/purge")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsPurgeContent_575352(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes a content from CDN.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575354 = path.getOrDefault("resourceGroupName")
  valid_575354 = validateParameter(valid_575354, JString, required = true,
                                 default = nil)
  if valid_575354 != nil:
    section.add "resourceGroupName", valid_575354
  var valid_575355 = path.getOrDefault("subscriptionId")
  valid_575355 = validateParameter(valid_575355, JString, required = true,
                                 default = nil)
  if valid_575355 != nil:
    section.add "subscriptionId", valid_575355
  var valid_575356 = path.getOrDefault("profileName")
  valid_575356 = validateParameter(valid_575356, JString, required = true,
                                 default = nil)
  if valid_575356 != nil:
    section.add "profileName", valid_575356
  var valid_575357 = path.getOrDefault("endpointName")
  valid_575357 = validateParameter(valid_575357, JString, required = true,
                                 default = nil)
  if valid_575357 != nil:
    section.add "endpointName", valid_575357
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575358 = query.getOrDefault("api-version")
  valid_575358 = validateParameter(valid_575358, JString, required = true,
                                 default = nil)
  if valid_575358 != nil:
    section.add "api-version", valid_575358
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   contentFilePaths: JObject (required)
  ##                   : The path to the content to be purged. Path can be a full URL, e.g. '/pictures/city.png' which removes a single file, or a directory with a wildcard, e.g. '/pictures/*' which removes all folders and files in the directory.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575360: Call_EndpointsPurgeContent_575351; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a content from CDN.
  ## 
  let valid = call_575360.validator(path, query, header, formData, body)
  let scheme = call_575360.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575360.url(scheme.get, call_575360.host, call_575360.base,
                         call_575360.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575360, url, valid)

proc call*(call_575361: Call_EndpointsPurgeContent_575351;
          resourceGroupName: string; contentFilePaths: JsonNode; apiVersion: string;
          subscriptionId: string; profileName: string; endpointName: string): Recallable =
  ## endpointsPurgeContent
  ## Removes a content from CDN.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   contentFilePaths: JObject (required)
  ##                   : The path to the content to be purged. Path can be a full URL, e.g. '/pictures/city.png' which removes a single file, or a directory with a wildcard, e.g. '/pictures/*' which removes all folders and files in the directory.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_575362 = newJObject()
  var query_575363 = newJObject()
  var body_575364 = newJObject()
  add(path_575362, "resourceGroupName", newJString(resourceGroupName))
  if contentFilePaths != nil:
    body_575364 = contentFilePaths
  add(query_575363, "api-version", newJString(apiVersion))
  add(path_575362, "subscriptionId", newJString(subscriptionId))
  add(path_575362, "profileName", newJString(profileName))
  add(path_575362, "endpointName", newJString(endpointName))
  result = call_575361.call(path_575362, query_575363, nil, nil, body_575364)

var endpointsPurgeContent* = Call_EndpointsPurgeContent_575351(
    name: "endpointsPurgeContent", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/purge",
    validator: validate_EndpointsPurgeContent_575352, base: "",
    url: url_EndpointsPurgeContent_575353, schemes: {Scheme.Https})
type
  Call_EndpointsStart_575365 = ref object of OpenApiRestCall_574467
proc url_EndpointsStart_575367(protocol: Scheme; host: string; base: string;
                              route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/start")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsStart_575366(path: JsonNode; query: JsonNode;
                                   header: JsonNode; formData: JsonNode;
                                   body: JsonNode): JsonNode =
  ## Starts an existing CDN endpoint that is on a stopped state.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575368 = path.getOrDefault("resourceGroupName")
  valid_575368 = validateParameter(valid_575368, JString, required = true,
                                 default = nil)
  if valid_575368 != nil:
    section.add "resourceGroupName", valid_575368
  var valid_575369 = path.getOrDefault("subscriptionId")
  valid_575369 = validateParameter(valid_575369, JString, required = true,
                                 default = nil)
  if valid_575369 != nil:
    section.add "subscriptionId", valid_575369
  var valid_575370 = path.getOrDefault("profileName")
  valid_575370 = validateParameter(valid_575370, JString, required = true,
                                 default = nil)
  if valid_575370 != nil:
    section.add "profileName", valid_575370
  var valid_575371 = path.getOrDefault("endpointName")
  valid_575371 = validateParameter(valid_575371, JString, required = true,
                                 default = nil)
  if valid_575371 != nil:
    section.add "endpointName", valid_575371
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575372 = query.getOrDefault("api-version")
  valid_575372 = validateParameter(valid_575372, JString, required = true,
                                 default = nil)
  if valid_575372 != nil:
    section.add "api-version", valid_575372
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575373: Call_EndpointsStart_575365; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts an existing CDN endpoint that is on a stopped state.
  ## 
  let valid = call_575373.validator(path, query, header, formData, body)
  let scheme = call_575373.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575373.url(scheme.get, call_575373.host, call_575373.base,
                         call_575373.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575373, url, valid)

proc call*(call_575374: Call_EndpointsStart_575365; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; profileName: string;
          endpointName: string): Recallable =
  ## endpointsStart
  ## Starts an existing CDN endpoint that is on a stopped state.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_575375 = newJObject()
  var query_575376 = newJObject()
  add(path_575375, "resourceGroupName", newJString(resourceGroupName))
  add(query_575376, "api-version", newJString(apiVersion))
  add(path_575375, "subscriptionId", newJString(subscriptionId))
  add(path_575375, "profileName", newJString(profileName))
  add(path_575375, "endpointName", newJString(endpointName))
  result = call_575374.call(path_575375, query_575376, nil, nil, nil)

var endpointsStart* = Call_EndpointsStart_575365(name: "endpointsStart",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/start",
    validator: validate_EndpointsStart_575366, base: "", url: url_EndpointsStart_575367,
    schemes: {Scheme.Https})
type
  Call_EndpointsStop_575377 = ref object of OpenApiRestCall_574467
proc url_EndpointsStop_575379(protocol: Scheme; host: string; base: string;
                             route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/stop")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsStop_575378(path: JsonNode; query: JsonNode; header: JsonNode;
                                  formData: JsonNode; body: JsonNode): JsonNode =
  ## Stops an existing running CDN endpoint.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575380 = path.getOrDefault("resourceGroupName")
  valid_575380 = validateParameter(valid_575380, JString, required = true,
                                 default = nil)
  if valid_575380 != nil:
    section.add "resourceGroupName", valid_575380
  var valid_575381 = path.getOrDefault("subscriptionId")
  valid_575381 = validateParameter(valid_575381, JString, required = true,
                                 default = nil)
  if valid_575381 != nil:
    section.add "subscriptionId", valid_575381
  var valid_575382 = path.getOrDefault("profileName")
  valid_575382 = validateParameter(valid_575382, JString, required = true,
                                 default = nil)
  if valid_575382 != nil:
    section.add "profileName", valid_575382
  var valid_575383 = path.getOrDefault("endpointName")
  valid_575383 = validateParameter(valid_575383, JString, required = true,
                                 default = nil)
  if valid_575383 != nil:
    section.add "endpointName", valid_575383
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575384 = query.getOrDefault("api-version")
  valid_575384 = validateParameter(valid_575384, JString, required = true,
                                 default = nil)
  if valid_575384 != nil:
    section.add "api-version", valid_575384
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575385: Call_EndpointsStop_575377; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops an existing running CDN endpoint.
  ## 
  let valid = call_575385.validator(path, query, header, formData, body)
  let scheme = call_575385.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575385.url(scheme.get, call_575385.host, call_575385.base,
                         call_575385.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575385, url, valid)

proc call*(call_575386: Call_EndpointsStop_575377; resourceGroupName: string;
          apiVersion: string; subscriptionId: string; profileName: string;
          endpointName: string): Recallable =
  ## endpointsStop
  ## Stops an existing running CDN endpoint.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_575387 = newJObject()
  var query_575388 = newJObject()
  add(path_575387, "resourceGroupName", newJString(resourceGroupName))
  add(query_575388, "api-version", newJString(apiVersion))
  add(path_575387, "subscriptionId", newJString(subscriptionId))
  add(path_575387, "profileName", newJString(profileName))
  add(path_575387, "endpointName", newJString(endpointName))
  result = call_575386.call(path_575387, query_575388, nil, nil, nil)

var endpointsStop* = Call_EndpointsStop_575377(name: "endpointsStop",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/stop",
    validator: validate_EndpointsStop_575378, base: "", url: url_EndpointsStop_575379,
    schemes: {Scheme.Https})
type
  Call_EndpointsValidateCustomDomain_575389 = ref object of OpenApiRestCall_574467
proc url_EndpointsValidateCustomDomain_575391(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  assert "endpointName" in path, "`endpointName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/endpoints/"),
               (kind: VariableSegment, value: "endpointName"),
               (kind: ConstantSegment, value: "/validateCustomDomain")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_EndpointsValidateCustomDomain_575390(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Validates the custom domain mapping to ensure it maps to the correct CDN endpoint in DNS.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: JString (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575392 = path.getOrDefault("resourceGroupName")
  valid_575392 = validateParameter(valid_575392, JString, required = true,
                                 default = nil)
  if valid_575392 != nil:
    section.add "resourceGroupName", valid_575392
  var valid_575393 = path.getOrDefault("subscriptionId")
  valid_575393 = validateParameter(valid_575393, JString, required = true,
                                 default = nil)
  if valid_575393 != nil:
    section.add "subscriptionId", valid_575393
  var valid_575394 = path.getOrDefault("profileName")
  valid_575394 = validateParameter(valid_575394, JString, required = true,
                                 default = nil)
  if valid_575394 != nil:
    section.add "profileName", valid_575394
  var valid_575395 = path.getOrDefault("endpointName")
  valid_575395 = validateParameter(valid_575395, JString, required = true,
                                 default = nil)
  if valid_575395 != nil:
    section.add "endpointName", valid_575395
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575396 = query.getOrDefault("api-version")
  valid_575396 = validateParameter(valid_575396, JString, required = true,
                                 default = nil)
  if valid_575396 != nil:
    section.add "api-version", valid_575396
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   customDomainProperties: JObject (required)
  ##                         : Custom domain to be validated.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575398: Call_EndpointsValidateCustomDomain_575389; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validates the custom domain mapping to ensure it maps to the correct CDN endpoint in DNS.
  ## 
  let valid = call_575398.validator(path, query, header, formData, body)
  let scheme = call_575398.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575398.url(scheme.get, call_575398.host, call_575398.base,
                         call_575398.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575398, url, valid)

proc call*(call_575399: Call_EndpointsValidateCustomDomain_575389;
          resourceGroupName: string; apiVersion: string;
          customDomainProperties: JsonNode; subscriptionId: string;
          profileName: string; endpointName: string): Recallable =
  ## endpointsValidateCustomDomain
  ## Validates the custom domain mapping to ensure it maps to the correct CDN endpoint in DNS.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   customDomainProperties: JObject (required)
  ##                         : Custom domain to be validated.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_575400 = newJObject()
  var query_575401 = newJObject()
  var body_575402 = newJObject()
  add(path_575400, "resourceGroupName", newJString(resourceGroupName))
  add(query_575401, "api-version", newJString(apiVersion))
  if customDomainProperties != nil:
    body_575402 = customDomainProperties
  add(path_575400, "subscriptionId", newJString(subscriptionId))
  add(path_575400, "profileName", newJString(profileName))
  add(path_575400, "endpointName", newJString(endpointName))
  result = call_575399.call(path_575400, query_575401, nil, nil, body_575402)

var endpointsValidateCustomDomain* = Call_EndpointsValidateCustomDomain_575389(
    name: "endpointsValidateCustomDomain", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/validateCustomDomain",
    validator: validate_EndpointsValidateCustomDomain_575390, base: "",
    url: url_EndpointsValidateCustomDomain_575391, schemes: {Scheme.Https})
type
  Call_ProfilesGenerateSsoUri_575403 = ref object of OpenApiRestCall_574467
proc url_ProfilesGenerateSsoUri_575405(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/generateSsoUri")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesGenerateSsoUri_575404(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generates a dynamic SSO URI used to sign in to the CDN supplemental portal. Supplemental portal is used to configure advanced feature capabilities that are not yet available in the Azure portal, such as core reports in a standard profile; rules engine, advanced HTTP reports, and real-time stats and alerts in a premium profile. The SSO URI changes approximately every 10 minutes.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575406 = path.getOrDefault("resourceGroupName")
  valid_575406 = validateParameter(valid_575406, JString, required = true,
                                 default = nil)
  if valid_575406 != nil:
    section.add "resourceGroupName", valid_575406
  var valid_575407 = path.getOrDefault("subscriptionId")
  valid_575407 = validateParameter(valid_575407, JString, required = true,
                                 default = nil)
  if valid_575407 != nil:
    section.add "subscriptionId", valid_575407
  var valid_575408 = path.getOrDefault("profileName")
  valid_575408 = validateParameter(valid_575408, JString, required = true,
                                 default = nil)
  if valid_575408 != nil:
    section.add "profileName", valid_575408
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575409 = query.getOrDefault("api-version")
  valid_575409 = validateParameter(valid_575409, JString, required = true,
                                 default = nil)
  if valid_575409 != nil:
    section.add "api-version", valid_575409
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575410: Call_ProfilesGenerateSsoUri_575403; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generates a dynamic SSO URI used to sign in to the CDN supplemental portal. Supplemental portal is used to configure advanced feature capabilities that are not yet available in the Azure portal, such as core reports in a standard profile; rules engine, advanced HTTP reports, and real-time stats and alerts in a premium profile. The SSO URI changes approximately every 10 minutes.
  ## 
  let valid = call_575410.validator(path, query, header, formData, body)
  let scheme = call_575410.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575410.url(scheme.get, call_575410.host, call_575410.base,
                         call_575410.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575410, url, valid)

proc call*(call_575411: Call_ProfilesGenerateSsoUri_575403;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          profileName: string): Recallable =
  ## profilesGenerateSsoUri
  ## Generates a dynamic SSO URI used to sign in to the CDN supplemental portal. Supplemental portal is used to configure advanced feature capabilities that are not yet available in the Azure portal, such as core reports in a standard profile; rules engine, advanced HTTP reports, and real-time stats and alerts in a premium profile. The SSO URI changes approximately every 10 minutes.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  var path_575412 = newJObject()
  var query_575413 = newJObject()
  add(path_575412, "resourceGroupName", newJString(resourceGroupName))
  add(query_575413, "api-version", newJString(apiVersion))
  add(path_575412, "subscriptionId", newJString(subscriptionId))
  add(path_575412, "profileName", newJString(profileName))
  result = call_575411.call(path_575412, query_575413, nil, nil, nil)

var profilesGenerateSsoUri* = Call_ProfilesGenerateSsoUri_575403(
    name: "profilesGenerateSsoUri", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/generateSsoUri",
    validator: validate_ProfilesGenerateSsoUri_575404, base: "",
    url: url_ProfilesGenerateSsoUri_575405, schemes: {Scheme.Https})
type
  Call_ProfilesListSupportedOptimizationTypes_575414 = ref object of OpenApiRestCall_574467
proc url_ProfilesListSupportedOptimizationTypes_575416(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "profileName" in path, "`profileName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment, value: "/providers/Microsoft.Cdn/profiles/"),
               (kind: VariableSegment, value: "profileName"),
               (kind: ConstantSegment, value: "/getSupportedOptimizationTypes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_ProfilesListSupportedOptimizationTypes_575415(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the supported optimization types for the current profile. A user can create an endpoint with an optimization type from the listed values.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   subscriptionId: JString (required)
  ##                 : Azure Subscription ID.
  ##   profileName: JString (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_575417 = path.getOrDefault("resourceGroupName")
  valid_575417 = validateParameter(valid_575417, JString, required = true,
                                 default = nil)
  if valid_575417 != nil:
    section.add "resourceGroupName", valid_575417
  var valid_575418 = path.getOrDefault("subscriptionId")
  valid_575418 = validateParameter(valid_575418, JString, required = true,
                                 default = nil)
  if valid_575418 != nil:
    section.add "subscriptionId", valid_575418
  var valid_575419 = path.getOrDefault("profileName")
  valid_575419 = validateParameter(valid_575419, JString, required = true,
                                 default = nil)
  if valid_575419 != nil:
    section.add "profileName", valid_575419
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575420 = query.getOrDefault("api-version")
  valid_575420 = validateParameter(valid_575420, JString, required = true,
                                 default = nil)
  if valid_575420 != nil:
    section.add "api-version", valid_575420
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575421: Call_ProfilesListSupportedOptimizationTypes_575414;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the supported optimization types for the current profile. A user can create an endpoint with an optimization type from the listed values.
  ## 
  let valid = call_575421.validator(path, query, header, formData, body)
  let scheme = call_575421.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575421.url(scheme.get, call_575421.host, call_575421.base,
                         call_575421.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575421, url, valid)

proc call*(call_575422: Call_ProfilesListSupportedOptimizationTypes_575414;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          profileName: string): Recallable =
  ## profilesListSupportedOptimizationTypes
  ## Gets the supported optimization types for the current profile. A user can create an endpoint with an optimization type from the listed values.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   profileName: string (required)
  ##              : Name of the CDN profile which is unique within the resource group.
  var path_575423 = newJObject()
  var query_575424 = newJObject()
  add(path_575423, "resourceGroupName", newJString(resourceGroupName))
  add(query_575424, "api-version", newJString(apiVersion))
  add(path_575423, "subscriptionId", newJString(subscriptionId))
  add(path_575423, "profileName", newJString(profileName))
  result = call_575422.call(path_575423, query_575424, nil, nil, nil)

var profilesListSupportedOptimizationTypes* = Call_ProfilesListSupportedOptimizationTypes_575414(
    name: "profilesListSupportedOptimizationTypes", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/getSupportedOptimizationTypes",
    validator: validate_ProfilesListSupportedOptimizationTypes_575415, base: "",
    url: url_ProfilesListSupportedOptimizationTypes_575416,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
