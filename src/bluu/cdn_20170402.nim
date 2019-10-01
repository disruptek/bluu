
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: CdnManagementClient
## version: 2017-04-02
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
  Call_ResourceUsageList_575001 = ref object of OpenApiRestCall_574467
proc url_ResourceUsageList_575003(protocol: Scheme; host: string; base: string;
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

proc validate_ResourceUsageList_575002(path: JsonNode; query: JsonNode;
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
  if body != nil:
    result.add "body", body

proc call*(call_575020: Call_ResourceUsageList_575001; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Check the quota and actual usage of the CDN profiles under the given subscription.
  ## 
  let valid = call_575020.validator(path, query, header, formData, body)
  let scheme = call_575020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575020.url(scheme.get, call_575020.host, call_575020.base,
                         call_575020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575020, url, valid)

proc call*(call_575021: Call_ResourceUsageList_575001; apiVersion: string;
          subscriptionId: string): Recallable =
  ## resourceUsageList
  ## Check the quota and actual usage of the CDN profiles under the given subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_575022 = newJObject()
  var query_575023 = newJObject()
  add(query_575023, "api-version", newJString(apiVersion))
  add(path_575022, "subscriptionId", newJString(subscriptionId))
  result = call_575021.call(path_575022, query_575023, nil, nil, nil)

var resourceUsageList* = Call_ResourceUsageList_575001(name: "resourceUsageList",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Cdn/checkResourceUsage",
    validator: validate_ResourceUsageList_575002, base: "",
    url: url_ResourceUsageList_575003, schemes: {Scheme.Https})
type
  Call_ProfilesList_575024 = ref object of OpenApiRestCall_574467
proc url_ProfilesList_575026(protocol: Scheme; host: string; base: string;
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

proc validate_ProfilesList_575025(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_575027 = path.getOrDefault("subscriptionId")
  valid_575027 = validateParameter(valid_575027, JString, required = true,
                                 default = nil)
  if valid_575027 != nil:
    section.add "subscriptionId", valid_575027
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575028 = query.getOrDefault("api-version")
  valid_575028 = validateParameter(valid_575028, JString, required = true,
                                 default = nil)
  if valid_575028 != nil:
    section.add "api-version", valid_575028
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575029: Call_ProfilesList_575024; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the CDN profiles within an Azure subscription.
  ## 
  let valid = call_575029.validator(path, query, header, formData, body)
  let scheme = call_575029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575029.url(scheme.get, call_575029.host, call_575029.base,
                         call_575029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575029, url, valid)

proc call*(call_575030: Call_ProfilesList_575024; apiVersion: string;
          subscriptionId: string): Recallable =
  ## profilesList
  ## Lists all of the CDN profiles within an Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_575031 = newJObject()
  var query_575032 = newJObject()
  add(query_575032, "api-version", newJString(apiVersion))
  add(path_575031, "subscriptionId", newJString(subscriptionId))
  result = call_575030.call(path_575031, query_575032, nil, nil, nil)

var profilesList* = Call_ProfilesList_575024(name: "profilesList",
    meth: HttpMethod.HttpGet, host: "management.azure.com",
    route: "/subscriptions/{subscriptionId}/providers/Microsoft.Cdn/profiles",
    validator: validate_ProfilesList_575025, base: "", url: url_ProfilesList_575026,
    schemes: {Scheme.Https})
type
  Call_ValidateProbe_575033 = ref object of OpenApiRestCall_574467
proc url_ValidateProbe_575035(protocol: Scheme; host: string; base: string;
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

proc validate_ValidateProbe_575034(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_575036 = path.getOrDefault("subscriptionId")
  valid_575036 = validateParameter(valid_575036, JString, required = true,
                                 default = nil)
  if valid_575036 != nil:
    section.add "subscriptionId", valid_575036
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575037 = query.getOrDefault("api-version")
  valid_575037 = validateParameter(valid_575037, JString, required = true,
                                 default = nil)
  if valid_575037 != nil:
    section.add "api-version", valid_575037
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

proc call*(call_575039: Call_ValidateProbe_575033; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Check if the probe path is a valid path and the file can be accessed. Probe path is the path to a file hosted on the origin server to help accelerate the delivery of dynamic content via the CDN endpoint. This path is relative to the origin path specified in the endpoint configuration.
  ## 
  let valid = call_575039.validator(path, query, header, formData, body)
  let scheme = call_575039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575039.url(scheme.get, call_575039.host, call_575039.base,
                         call_575039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575039, url, valid)

proc call*(call_575040: Call_ValidateProbe_575033; apiVersion: string;
          subscriptionId: string; validateProbeInput: JsonNode): Recallable =
  ## validateProbe
  ## Check if the probe path is a valid path and the file can be accessed. Probe path is the path to a file hosted on the origin server to help accelerate the delivery of dynamic content via the CDN endpoint. This path is relative to the origin path specified in the endpoint configuration.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  ##   validateProbeInput: JObject (required)
  ##                     : Input to check.
  var path_575041 = newJObject()
  var query_575042 = newJObject()
  var body_575043 = newJObject()
  add(query_575042, "api-version", newJString(apiVersion))
  add(path_575041, "subscriptionId", newJString(subscriptionId))
  if validateProbeInput != nil:
    body_575043 = validateProbeInput
  result = call_575040.call(path_575041, query_575042, nil, nil, body_575043)

var validateProbe* = Call_ValidateProbe_575033(name: "validateProbe",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/providers/Microsoft.Cdn/validateProbe",
    validator: validate_ValidateProbe_575034, base: "", url: url_ValidateProbe_575035,
    schemes: {Scheme.Https})
type
  Call_ProfilesListByResourceGroup_575044 = ref object of OpenApiRestCall_574467
proc url_ProfilesListByResourceGroup_575046(protocol: Scheme; host: string;
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

proc validate_ProfilesListByResourceGroup_575045(path: JsonNode; query: JsonNode;
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
  var valid_575047 = path.getOrDefault("resourceGroupName")
  valid_575047 = validateParameter(valid_575047, JString, required = true,
                                 default = nil)
  if valid_575047 != nil:
    section.add "resourceGroupName", valid_575047
  var valid_575048 = path.getOrDefault("subscriptionId")
  valid_575048 = validateParameter(valid_575048, JString, required = true,
                                 default = nil)
  if valid_575048 != nil:
    section.add "subscriptionId", valid_575048
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575049 = query.getOrDefault("api-version")
  valid_575049 = validateParameter(valid_575049, JString, required = true,
                                 default = nil)
  if valid_575049 != nil:
    section.add "api-version", valid_575049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575050: Call_ProfilesListByResourceGroup_575044; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the CDN profiles within a resource group.
  ## 
  let valid = call_575050.validator(path, query, header, formData, body)
  let scheme = call_575050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575050.url(scheme.get, call_575050.host, call_575050.base,
                         call_575050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575050, url, valid)

proc call*(call_575051: Call_ProfilesListByResourceGroup_575044;
          resourceGroupName: string; apiVersion: string; subscriptionId: string): Recallable =
  ## profilesListByResourceGroup
  ## Lists all of the CDN profiles within a resource group.
  ##   resourceGroupName: string (required)
  ##                    : Name of the Resource group within the Azure subscription.
  ##   apiVersion: string (required)
  ##             : Version of the API to be used with the client request. Current version is 2017-04-02.
  ##   subscriptionId: string (required)
  ##                 : Azure Subscription ID.
  var path_575052 = newJObject()
  var query_575053 = newJObject()
  add(path_575052, "resourceGroupName", newJString(resourceGroupName))
  add(query_575053, "api-version", newJString(apiVersion))
  add(path_575052, "subscriptionId", newJString(subscriptionId))
  result = call_575051.call(path_575052, query_575053, nil, nil, nil)

var profilesListByResourceGroup* = Call_ProfilesListByResourceGroup_575044(
    name: "profilesListByResourceGroup", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles",
    validator: validate_ProfilesListByResourceGroup_575045, base: "",
    url: url_ProfilesListByResourceGroup_575046, schemes: {Scheme.Https})
type
  Call_ProfilesCreate_575065 = ref object of OpenApiRestCall_574467
proc url_ProfilesCreate_575067(protocol: Scheme; host: string; base: string;
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

proc validate_ProfilesCreate_575066(path: JsonNode; query: JsonNode;
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
  ## parameters in `body` object:
  ##   profile: JObject (required)
  ##          : Profile properties needed to create a new profile.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575073: Call_ProfilesCreate_575065; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new CDN profile with a profile name under the specified subscription and resource group.
  ## 
  let valid = call_575073.validator(path, query, header, formData, body)
  let scheme = call_575073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575073.url(scheme.get, call_575073.host, call_575073.base,
                         call_575073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575073, url, valid)

proc call*(call_575074: Call_ProfilesCreate_575065; resourceGroupName: string;
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
  var path_575075 = newJObject()
  var query_575076 = newJObject()
  var body_575077 = newJObject()
  add(path_575075, "resourceGroupName", newJString(resourceGroupName))
  add(query_575076, "api-version", newJString(apiVersion))
  add(path_575075, "subscriptionId", newJString(subscriptionId))
  add(path_575075, "profileName", newJString(profileName))
  if profile != nil:
    body_575077 = profile
  result = call_575074.call(path_575075, query_575076, nil, nil, body_575077)

var profilesCreate* = Call_ProfilesCreate_575065(name: "profilesCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}",
    validator: validate_ProfilesCreate_575066, base: "", url: url_ProfilesCreate_575067,
    schemes: {Scheme.Https})
type
  Call_ProfilesGet_575054 = ref object of OpenApiRestCall_574467
proc url_ProfilesGet_575056(protocol: Scheme; host: string; base: string;
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

proc validate_ProfilesGet_575055(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_575057 = path.getOrDefault("resourceGroupName")
  valid_575057 = validateParameter(valid_575057, JString, required = true,
                                 default = nil)
  if valid_575057 != nil:
    section.add "resourceGroupName", valid_575057
  var valid_575058 = path.getOrDefault("subscriptionId")
  valid_575058 = validateParameter(valid_575058, JString, required = true,
                                 default = nil)
  if valid_575058 != nil:
    section.add "subscriptionId", valid_575058
  var valid_575059 = path.getOrDefault("profileName")
  valid_575059 = validateParameter(valid_575059, JString, required = true,
                                 default = nil)
  if valid_575059 != nil:
    section.add "profileName", valid_575059
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

proc call*(call_575061: Call_ProfilesGet_575054; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a CDN profile with the specified profile name under the specified subscription and resource group.
  ## 
  let valid = call_575061.validator(path, query, header, formData, body)
  let scheme = call_575061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575061.url(scheme.get, call_575061.host, call_575061.base,
                         call_575061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575061, url, valid)

proc call*(call_575062: Call_ProfilesGet_575054; resourceGroupName: string;
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
  var path_575063 = newJObject()
  var query_575064 = newJObject()
  add(path_575063, "resourceGroupName", newJString(resourceGroupName))
  add(query_575064, "api-version", newJString(apiVersion))
  add(path_575063, "subscriptionId", newJString(subscriptionId))
  add(path_575063, "profileName", newJString(profileName))
  result = call_575062.call(path_575063, query_575064, nil, nil, nil)

var profilesGet* = Call_ProfilesGet_575054(name: "profilesGet",
                                        meth: HttpMethod.HttpGet,
                                        host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}",
                                        validator: validate_ProfilesGet_575055,
                                        base: "", url: url_ProfilesGet_575056,
                                        schemes: {Scheme.Https})
type
  Call_ProfilesUpdate_575089 = ref object of OpenApiRestCall_574467
proc url_ProfilesUpdate_575091(protocol: Scheme; host: string; base: string;
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

proc validate_ProfilesUpdate_575090(path: JsonNode; query: JsonNode;
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
  ## parameters in `body` object:
  ##   profileUpdateParameters: JObject (required)
  ##                          : Profile properties needed to update an existing profile.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_575097: Call_ProfilesUpdate_575089; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing CDN profile with the specified profile name under the specified subscription and resource group.
  ## 
  let valid = call_575097.validator(path, query, header, formData, body)
  let scheme = call_575097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575097.url(scheme.get, call_575097.host, call_575097.base,
                         call_575097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575097, url, valid)

proc call*(call_575098: Call_ProfilesUpdate_575089; resourceGroupName: string;
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
  var path_575099 = newJObject()
  var query_575100 = newJObject()
  var body_575101 = newJObject()
  add(path_575099, "resourceGroupName", newJString(resourceGroupName))
  add(query_575100, "api-version", newJString(apiVersion))
  add(path_575099, "subscriptionId", newJString(subscriptionId))
  add(path_575099, "profileName", newJString(profileName))
  if profileUpdateParameters != nil:
    body_575101 = profileUpdateParameters
  result = call_575098.call(path_575099, query_575100, nil, nil, body_575101)

var profilesUpdate* = Call_ProfilesUpdate_575089(name: "profilesUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}",
    validator: validate_ProfilesUpdate_575090, base: "", url: url_ProfilesUpdate_575091,
    schemes: {Scheme.Https})
type
  Call_ProfilesDelete_575078 = ref object of OpenApiRestCall_574467
proc url_ProfilesDelete_575080(protocol: Scheme; host: string; base: string;
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

proc validate_ProfilesDelete_575079(path: JsonNode; query: JsonNode;
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
  var valid_575081 = path.getOrDefault("resourceGroupName")
  valid_575081 = validateParameter(valid_575081, JString, required = true,
                                 default = nil)
  if valid_575081 != nil:
    section.add "resourceGroupName", valid_575081
  var valid_575082 = path.getOrDefault("subscriptionId")
  valid_575082 = validateParameter(valid_575082, JString, required = true,
                                 default = nil)
  if valid_575082 != nil:
    section.add "subscriptionId", valid_575082
  var valid_575083 = path.getOrDefault("profileName")
  valid_575083 = validateParameter(valid_575083, JString, required = true,
                                 default = nil)
  if valid_575083 != nil:
    section.add "profileName", valid_575083
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575084 = query.getOrDefault("api-version")
  valid_575084 = validateParameter(valid_575084, JString, required = true,
                                 default = nil)
  if valid_575084 != nil:
    section.add "api-version", valid_575084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575085: Call_ProfilesDelete_575078; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing CDN profile with the specified parameters. Deleting a profile will result in the deletion of all of the sub-resources including endpoints, origins and custom domains.
  ## 
  let valid = call_575085.validator(path, query, header, formData, body)
  let scheme = call_575085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575085.url(scheme.get, call_575085.host, call_575085.base,
                         call_575085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575085, url, valid)

proc call*(call_575086: Call_ProfilesDelete_575078; resourceGroupName: string;
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
  var path_575087 = newJObject()
  var query_575088 = newJObject()
  add(path_575087, "resourceGroupName", newJString(resourceGroupName))
  add(query_575088, "api-version", newJString(apiVersion))
  add(path_575087, "subscriptionId", newJString(subscriptionId))
  add(path_575087, "profileName", newJString(profileName))
  result = call_575086.call(path_575087, query_575088, nil, nil, nil)

var profilesDelete* = Call_ProfilesDelete_575078(name: "profilesDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}",
    validator: validate_ProfilesDelete_575079, base: "", url: url_ProfilesDelete_575080,
    schemes: {Scheme.Https})
type
  Call_ProfilesListResourceUsage_575102 = ref object of OpenApiRestCall_574467
proc url_ProfilesListResourceUsage_575104(protocol: Scheme; host: string;
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

proc validate_ProfilesListResourceUsage_575103(path: JsonNode; query: JsonNode;
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
  var valid_575105 = path.getOrDefault("resourceGroupName")
  valid_575105 = validateParameter(valid_575105, JString, required = true,
                                 default = nil)
  if valid_575105 != nil:
    section.add "resourceGroupName", valid_575105
  var valid_575106 = path.getOrDefault("subscriptionId")
  valid_575106 = validateParameter(valid_575106, JString, required = true,
                                 default = nil)
  if valid_575106 != nil:
    section.add "subscriptionId", valid_575106
  var valid_575107 = path.getOrDefault("profileName")
  valid_575107 = validateParameter(valid_575107, JString, required = true,
                                 default = nil)
  if valid_575107 != nil:
    section.add "profileName", valid_575107
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575108 = query.getOrDefault("api-version")
  valid_575108 = validateParameter(valid_575108, JString, required = true,
                                 default = nil)
  if valid_575108 != nil:
    section.add "api-version", valid_575108
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575109: Call_ProfilesListResourceUsage_575102; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks the quota and actual usage of endpoints under the given CDN profile.
  ## 
  let valid = call_575109.validator(path, query, header, formData, body)
  let scheme = call_575109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575109.url(scheme.get, call_575109.host, call_575109.base,
                         call_575109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575109, url, valid)

proc call*(call_575110: Call_ProfilesListResourceUsage_575102;
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
  var path_575111 = newJObject()
  var query_575112 = newJObject()
  add(path_575111, "resourceGroupName", newJString(resourceGroupName))
  add(query_575112, "api-version", newJString(apiVersion))
  add(path_575111, "subscriptionId", newJString(subscriptionId))
  add(path_575111, "profileName", newJString(profileName))
  result = call_575110.call(path_575111, query_575112, nil, nil, nil)

var profilesListResourceUsage* = Call_ProfilesListResourceUsage_575102(
    name: "profilesListResourceUsage", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/checkResourceUsage",
    validator: validate_ProfilesListResourceUsage_575103, base: "",
    url: url_ProfilesListResourceUsage_575104, schemes: {Scheme.Https})
type
  Call_EndpointsListByProfile_575113 = ref object of OpenApiRestCall_574467
proc url_EndpointsListByProfile_575115(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsListByProfile_575114(path: JsonNode; query: JsonNode;
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

proc call*(call_575120: Call_EndpointsListByProfile_575113; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists existing CDN endpoints.
  ## 
  let valid = call_575120.validator(path, query, header, formData, body)
  let scheme = call_575120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575120.url(scheme.get, call_575120.host, call_575120.base,
                         call_575120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575120, url, valid)

proc call*(call_575121: Call_EndpointsListByProfile_575113;
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
  var path_575122 = newJObject()
  var query_575123 = newJObject()
  add(path_575122, "resourceGroupName", newJString(resourceGroupName))
  add(query_575123, "api-version", newJString(apiVersion))
  add(path_575122, "subscriptionId", newJString(subscriptionId))
  add(path_575122, "profileName", newJString(profileName))
  result = call_575121.call(path_575122, query_575123, nil, nil, nil)

var endpointsListByProfile* = Call_EndpointsListByProfile_575113(
    name: "endpointsListByProfile", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints",
    validator: validate_EndpointsListByProfile_575114, base: "",
    url: url_EndpointsListByProfile_575115, schemes: {Scheme.Https})
type
  Call_EndpointsCreate_575136 = ref object of OpenApiRestCall_574467
proc url_EndpointsCreate_575138(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsCreate_575137(path: JsonNode; query: JsonNode;
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
  var valid_575139 = path.getOrDefault("resourceGroupName")
  valid_575139 = validateParameter(valid_575139, JString, required = true,
                                 default = nil)
  if valid_575139 != nil:
    section.add "resourceGroupName", valid_575139
  var valid_575140 = path.getOrDefault("subscriptionId")
  valid_575140 = validateParameter(valid_575140, JString, required = true,
                                 default = nil)
  if valid_575140 != nil:
    section.add "subscriptionId", valid_575140
  var valid_575141 = path.getOrDefault("profileName")
  valid_575141 = validateParameter(valid_575141, JString, required = true,
                                 default = nil)
  if valid_575141 != nil:
    section.add "profileName", valid_575141
  var valid_575142 = path.getOrDefault("endpointName")
  valid_575142 = validateParameter(valid_575142, JString, required = true,
                                 default = nil)
  if valid_575142 != nil:
    section.add "endpointName", valid_575142
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575143 = query.getOrDefault("api-version")
  valid_575143 = validateParameter(valid_575143, JString, required = true,
                                 default = nil)
  if valid_575143 != nil:
    section.add "api-version", valid_575143
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

proc call*(call_575145: Call_EndpointsCreate_575136; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile.
  ## 
  let valid = call_575145.validator(path, query, header, formData, body)
  let scheme = call_575145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575145.url(scheme.get, call_575145.host, call_575145.base,
                         call_575145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575145, url, valid)

proc call*(call_575146: Call_EndpointsCreate_575136; resourceGroupName: string;
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
  var path_575147 = newJObject()
  var query_575148 = newJObject()
  var body_575149 = newJObject()
  add(path_575147, "resourceGroupName", newJString(resourceGroupName))
  add(query_575148, "api-version", newJString(apiVersion))
  if endpoint != nil:
    body_575149 = endpoint
  add(path_575147, "subscriptionId", newJString(subscriptionId))
  add(path_575147, "profileName", newJString(profileName))
  add(path_575147, "endpointName", newJString(endpointName))
  result = call_575146.call(path_575147, query_575148, nil, nil, body_575149)

var endpointsCreate* = Call_EndpointsCreate_575136(name: "endpointsCreate",
    meth: HttpMethod.HttpPut, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}",
    validator: validate_EndpointsCreate_575137, base: "", url: url_EndpointsCreate_575138,
    schemes: {Scheme.Https})
type
  Call_EndpointsGet_575124 = ref object of OpenApiRestCall_574467
proc url_EndpointsGet_575126(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsGet_575125(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_575130 = path.getOrDefault("endpointName")
  valid_575130 = validateParameter(valid_575130, JString, required = true,
                                 default = nil)
  if valid_575130 != nil:
    section.add "endpointName", valid_575130
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575131 = query.getOrDefault("api-version")
  valid_575131 = validateParameter(valid_575131, JString, required = true,
                                 default = nil)
  if valid_575131 != nil:
    section.add "api-version", valid_575131
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575132: Call_EndpointsGet_575124; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an existing CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile.
  ## 
  let valid = call_575132.validator(path, query, header, formData, body)
  let scheme = call_575132.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575132.url(scheme.get, call_575132.host, call_575132.base,
                         call_575132.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575132, url, valid)

proc call*(call_575133: Call_EndpointsGet_575124; resourceGroupName: string;
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
  var path_575134 = newJObject()
  var query_575135 = newJObject()
  add(path_575134, "resourceGroupName", newJString(resourceGroupName))
  add(query_575135, "api-version", newJString(apiVersion))
  add(path_575134, "subscriptionId", newJString(subscriptionId))
  add(path_575134, "profileName", newJString(profileName))
  add(path_575134, "endpointName", newJString(endpointName))
  result = call_575133.call(path_575134, query_575135, nil, nil, nil)

var endpointsGet* = Call_EndpointsGet_575124(name: "endpointsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}",
    validator: validate_EndpointsGet_575125, base: "", url: url_EndpointsGet_575126,
    schemes: {Scheme.Https})
type
  Call_EndpointsUpdate_575162 = ref object of OpenApiRestCall_574467
proc url_EndpointsUpdate_575164(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsUpdate_575163(path: JsonNode; query: JsonNode;
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
  var valid_575165 = path.getOrDefault("resourceGroupName")
  valid_575165 = validateParameter(valid_575165, JString, required = true,
                                 default = nil)
  if valid_575165 != nil:
    section.add "resourceGroupName", valid_575165
  var valid_575166 = path.getOrDefault("subscriptionId")
  valid_575166 = validateParameter(valid_575166, JString, required = true,
                                 default = nil)
  if valid_575166 != nil:
    section.add "subscriptionId", valid_575166
  var valid_575167 = path.getOrDefault("profileName")
  valid_575167 = validateParameter(valid_575167, JString, required = true,
                                 default = nil)
  if valid_575167 != nil:
    section.add "profileName", valid_575167
  var valid_575168 = path.getOrDefault("endpointName")
  valid_575168 = validateParameter(valid_575168, JString, required = true,
                                 default = nil)
  if valid_575168 != nil:
    section.add "endpointName", valid_575168
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575169 = query.getOrDefault("api-version")
  valid_575169 = validateParameter(valid_575169, JString, required = true,
                                 default = nil)
  if valid_575169 != nil:
    section.add "api-version", valid_575169
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

proc call*(call_575171: Call_EndpointsUpdate_575162; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile. Only tags and Origin HostHeader can be updated after creating an endpoint. To update origins, use the Update Origin operation. To update custom domains, use the Update Custom Domain operation.
  ## 
  let valid = call_575171.validator(path, query, header, formData, body)
  let scheme = call_575171.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575171.url(scheme.get, call_575171.host, call_575171.base,
                         call_575171.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575171, url, valid)

proc call*(call_575172: Call_EndpointsUpdate_575162; resourceGroupName: string;
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
  var path_575173 = newJObject()
  var query_575174 = newJObject()
  var body_575175 = newJObject()
  add(path_575173, "resourceGroupName", newJString(resourceGroupName))
  if endpointUpdateProperties != nil:
    body_575175 = endpointUpdateProperties
  add(query_575174, "api-version", newJString(apiVersion))
  add(path_575173, "subscriptionId", newJString(subscriptionId))
  add(path_575173, "profileName", newJString(profileName))
  add(path_575173, "endpointName", newJString(endpointName))
  result = call_575172.call(path_575173, query_575174, nil, nil, body_575175)

var endpointsUpdate* = Call_EndpointsUpdate_575162(name: "endpointsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}",
    validator: validate_EndpointsUpdate_575163, base: "", url: url_EndpointsUpdate_575164,
    schemes: {Scheme.Https})
type
  Call_EndpointsDelete_575150 = ref object of OpenApiRestCall_574467
proc url_EndpointsDelete_575152(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsDelete_575151(path: JsonNode; query: JsonNode;
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
  var valid_575153 = path.getOrDefault("resourceGroupName")
  valid_575153 = validateParameter(valid_575153, JString, required = true,
                                 default = nil)
  if valid_575153 != nil:
    section.add "resourceGroupName", valid_575153
  var valid_575154 = path.getOrDefault("subscriptionId")
  valid_575154 = validateParameter(valid_575154, JString, required = true,
                                 default = nil)
  if valid_575154 != nil:
    section.add "subscriptionId", valid_575154
  var valid_575155 = path.getOrDefault("profileName")
  valid_575155 = validateParameter(valid_575155, JString, required = true,
                                 default = nil)
  if valid_575155 != nil:
    section.add "profileName", valid_575155
  var valid_575156 = path.getOrDefault("endpointName")
  valid_575156 = validateParameter(valid_575156, JString, required = true,
                                 default = nil)
  if valid_575156 != nil:
    section.add "endpointName", valid_575156
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575157 = query.getOrDefault("api-version")
  valid_575157 = validateParameter(valid_575157, JString, required = true,
                                 default = nil)
  if valid_575157 != nil:
    section.add "api-version", valid_575157
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575158: Call_EndpointsDelete_575150; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing CDN endpoint with the specified endpoint name under the specified subscription, resource group and profile.
  ## 
  let valid = call_575158.validator(path, query, header, formData, body)
  let scheme = call_575158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575158.url(scheme.get, call_575158.host, call_575158.base,
                         call_575158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575158, url, valid)

proc call*(call_575159: Call_EndpointsDelete_575150; resourceGroupName: string;
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
  var path_575160 = newJObject()
  var query_575161 = newJObject()
  add(path_575160, "resourceGroupName", newJString(resourceGroupName))
  add(query_575161, "api-version", newJString(apiVersion))
  add(path_575160, "subscriptionId", newJString(subscriptionId))
  add(path_575160, "profileName", newJString(profileName))
  add(path_575160, "endpointName", newJString(endpointName))
  result = call_575159.call(path_575160, query_575161, nil, nil, nil)

var endpointsDelete* = Call_EndpointsDelete_575150(name: "endpointsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}",
    validator: validate_EndpointsDelete_575151, base: "", url: url_EndpointsDelete_575152,
    schemes: {Scheme.Https})
type
  Call_EndpointsListResourceUsage_575176 = ref object of OpenApiRestCall_574467
proc url_EndpointsListResourceUsage_575178(protocol: Scheme; host: string;
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

proc validate_EndpointsListResourceUsage_575177(path: JsonNode; query: JsonNode;
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
  var valid_575179 = path.getOrDefault("resourceGroupName")
  valid_575179 = validateParameter(valid_575179, JString, required = true,
                                 default = nil)
  if valid_575179 != nil:
    section.add "resourceGroupName", valid_575179
  var valid_575180 = path.getOrDefault("subscriptionId")
  valid_575180 = validateParameter(valid_575180, JString, required = true,
                                 default = nil)
  if valid_575180 != nil:
    section.add "subscriptionId", valid_575180
  var valid_575181 = path.getOrDefault("profileName")
  valid_575181 = validateParameter(valid_575181, JString, required = true,
                                 default = nil)
  if valid_575181 != nil:
    section.add "profileName", valid_575181
  var valid_575182 = path.getOrDefault("endpointName")
  valid_575182 = validateParameter(valid_575182, JString, required = true,
                                 default = nil)
  if valid_575182 != nil:
    section.add "endpointName", valid_575182
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575183 = query.getOrDefault("api-version")
  valid_575183 = validateParameter(valid_575183, JString, required = true,
                                 default = nil)
  if valid_575183 != nil:
    section.add "api-version", valid_575183
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575184: Call_EndpointsListResourceUsage_575176; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks the quota and usage of geo filters and custom domains under the given endpoint.
  ## 
  let valid = call_575184.validator(path, query, header, formData, body)
  let scheme = call_575184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575184.url(scheme.get, call_575184.host, call_575184.base,
                         call_575184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575184, url, valid)

proc call*(call_575185: Call_EndpointsListResourceUsage_575176;
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
  var path_575186 = newJObject()
  var query_575187 = newJObject()
  add(path_575186, "resourceGroupName", newJString(resourceGroupName))
  add(query_575187, "api-version", newJString(apiVersion))
  add(path_575186, "subscriptionId", newJString(subscriptionId))
  add(path_575186, "profileName", newJString(profileName))
  add(path_575186, "endpointName", newJString(endpointName))
  result = call_575185.call(path_575186, query_575187, nil, nil, nil)

var endpointsListResourceUsage* = Call_EndpointsListResourceUsage_575176(
    name: "endpointsListResourceUsage", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/checkResourceUsage",
    validator: validate_EndpointsListResourceUsage_575177, base: "",
    url: url_EndpointsListResourceUsage_575178, schemes: {Scheme.Https})
type
  Call_CustomDomainsListByEndpoint_575188 = ref object of OpenApiRestCall_574467
proc url_CustomDomainsListByEndpoint_575190(protocol: Scheme; host: string;
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

proc validate_CustomDomainsListByEndpoint_575189(path: JsonNode; query: JsonNode;
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
  var valid_575191 = path.getOrDefault("resourceGroupName")
  valid_575191 = validateParameter(valid_575191, JString, required = true,
                                 default = nil)
  if valid_575191 != nil:
    section.add "resourceGroupName", valid_575191
  var valid_575192 = path.getOrDefault("subscriptionId")
  valid_575192 = validateParameter(valid_575192, JString, required = true,
                                 default = nil)
  if valid_575192 != nil:
    section.add "subscriptionId", valid_575192
  var valid_575193 = path.getOrDefault("profileName")
  valid_575193 = validateParameter(valid_575193, JString, required = true,
                                 default = nil)
  if valid_575193 != nil:
    section.add "profileName", valid_575193
  var valid_575194 = path.getOrDefault("endpointName")
  valid_575194 = validateParameter(valid_575194, JString, required = true,
                                 default = nil)
  if valid_575194 != nil:
    section.add "endpointName", valid_575194
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575195 = query.getOrDefault("api-version")
  valid_575195 = validateParameter(valid_575195, JString, required = true,
                                 default = nil)
  if valid_575195 != nil:
    section.add "api-version", valid_575195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575196: Call_CustomDomainsListByEndpoint_575188; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the existing custom domains within an endpoint.
  ## 
  let valid = call_575196.validator(path, query, header, formData, body)
  let scheme = call_575196.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575196.url(scheme.get, call_575196.host, call_575196.base,
                         call_575196.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575196, url, valid)

proc call*(call_575197: Call_CustomDomainsListByEndpoint_575188;
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
  var path_575198 = newJObject()
  var query_575199 = newJObject()
  add(path_575198, "resourceGroupName", newJString(resourceGroupName))
  add(query_575199, "api-version", newJString(apiVersion))
  add(path_575198, "subscriptionId", newJString(subscriptionId))
  add(path_575198, "profileName", newJString(profileName))
  add(path_575198, "endpointName", newJString(endpointName))
  result = call_575197.call(path_575198, query_575199, nil, nil, nil)

var customDomainsListByEndpoint* = Call_CustomDomainsListByEndpoint_575188(
    name: "customDomainsListByEndpoint", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/customDomains",
    validator: validate_CustomDomainsListByEndpoint_575189, base: "",
    url: url_CustomDomainsListByEndpoint_575190, schemes: {Scheme.Https})
type
  Call_CustomDomainsCreate_575213 = ref object of OpenApiRestCall_574467
proc url_CustomDomainsCreate_575215(protocol: Scheme; host: string; base: string;
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

proc validate_CustomDomainsCreate_575214(path: JsonNode; query: JsonNode;
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
  var valid_575216 = path.getOrDefault("resourceGroupName")
  valid_575216 = validateParameter(valid_575216, JString, required = true,
                                 default = nil)
  if valid_575216 != nil:
    section.add "resourceGroupName", valid_575216
  var valid_575217 = path.getOrDefault("subscriptionId")
  valid_575217 = validateParameter(valid_575217, JString, required = true,
                                 default = nil)
  if valid_575217 != nil:
    section.add "subscriptionId", valid_575217
  var valid_575218 = path.getOrDefault("customDomainName")
  valid_575218 = validateParameter(valid_575218, JString, required = true,
                                 default = nil)
  if valid_575218 != nil:
    section.add "customDomainName", valid_575218
  var valid_575219 = path.getOrDefault("profileName")
  valid_575219 = validateParameter(valid_575219, JString, required = true,
                                 default = nil)
  if valid_575219 != nil:
    section.add "profileName", valid_575219
  var valid_575220 = path.getOrDefault("endpointName")
  valid_575220 = validateParameter(valid_575220, JString, required = true,
                                 default = nil)
  if valid_575220 != nil:
    section.add "endpointName", valid_575220
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575221 = query.getOrDefault("api-version")
  valid_575221 = validateParameter(valid_575221, JString, required = true,
                                 default = nil)
  if valid_575221 != nil:
    section.add "api-version", valid_575221
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

proc call*(call_575223: Call_CustomDomainsCreate_575213; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new custom domain within an endpoint.
  ## 
  let valid = call_575223.validator(path, query, header, formData, body)
  let scheme = call_575223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575223.url(scheme.get, call_575223.host, call_575223.base,
                         call_575223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575223, url, valid)

proc call*(call_575224: Call_CustomDomainsCreate_575213; resourceGroupName: string;
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
  var path_575225 = newJObject()
  var query_575226 = newJObject()
  var body_575227 = newJObject()
  add(path_575225, "resourceGroupName", newJString(resourceGroupName))
  add(query_575226, "api-version", newJString(apiVersion))
  if customDomainProperties != nil:
    body_575227 = customDomainProperties
  add(path_575225, "subscriptionId", newJString(subscriptionId))
  add(path_575225, "customDomainName", newJString(customDomainName))
  add(path_575225, "profileName", newJString(profileName))
  add(path_575225, "endpointName", newJString(endpointName))
  result = call_575224.call(path_575225, query_575226, nil, nil, body_575227)

var customDomainsCreate* = Call_CustomDomainsCreate_575213(
    name: "customDomainsCreate", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/customDomains/{customDomainName}",
    validator: validate_CustomDomainsCreate_575214, base: "",
    url: url_CustomDomainsCreate_575215, schemes: {Scheme.Https})
type
  Call_CustomDomainsGet_575200 = ref object of OpenApiRestCall_574467
proc url_CustomDomainsGet_575202(protocol: Scheme; host: string; base: string;
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

proc validate_CustomDomainsGet_575201(path: JsonNode; query: JsonNode;
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
  var valid_575203 = path.getOrDefault("resourceGroupName")
  valid_575203 = validateParameter(valid_575203, JString, required = true,
                                 default = nil)
  if valid_575203 != nil:
    section.add "resourceGroupName", valid_575203
  var valid_575204 = path.getOrDefault("subscriptionId")
  valid_575204 = validateParameter(valid_575204, JString, required = true,
                                 default = nil)
  if valid_575204 != nil:
    section.add "subscriptionId", valid_575204
  var valid_575205 = path.getOrDefault("customDomainName")
  valid_575205 = validateParameter(valid_575205, JString, required = true,
                                 default = nil)
  if valid_575205 != nil:
    section.add "customDomainName", valid_575205
  var valid_575206 = path.getOrDefault("profileName")
  valid_575206 = validateParameter(valid_575206, JString, required = true,
                                 default = nil)
  if valid_575206 != nil:
    section.add "profileName", valid_575206
  var valid_575207 = path.getOrDefault("endpointName")
  valid_575207 = validateParameter(valid_575207, JString, required = true,
                                 default = nil)
  if valid_575207 != nil:
    section.add "endpointName", valid_575207
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575208 = query.getOrDefault("api-version")
  valid_575208 = validateParameter(valid_575208, JString, required = true,
                                 default = nil)
  if valid_575208 != nil:
    section.add "api-version", valid_575208
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575209: Call_CustomDomainsGet_575200; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an existing custom domain within an endpoint.
  ## 
  let valid = call_575209.validator(path, query, header, formData, body)
  let scheme = call_575209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575209.url(scheme.get, call_575209.host, call_575209.base,
                         call_575209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575209, url, valid)

proc call*(call_575210: Call_CustomDomainsGet_575200; resourceGroupName: string;
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
  var path_575211 = newJObject()
  var query_575212 = newJObject()
  add(path_575211, "resourceGroupName", newJString(resourceGroupName))
  add(query_575212, "api-version", newJString(apiVersion))
  add(path_575211, "subscriptionId", newJString(subscriptionId))
  add(path_575211, "customDomainName", newJString(customDomainName))
  add(path_575211, "profileName", newJString(profileName))
  add(path_575211, "endpointName", newJString(endpointName))
  result = call_575210.call(path_575211, query_575212, nil, nil, nil)

var customDomainsGet* = Call_CustomDomainsGet_575200(name: "customDomainsGet",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/customDomains/{customDomainName}",
    validator: validate_CustomDomainsGet_575201, base: "",
    url: url_CustomDomainsGet_575202, schemes: {Scheme.Https})
type
  Call_CustomDomainsDelete_575228 = ref object of OpenApiRestCall_574467
proc url_CustomDomainsDelete_575230(protocol: Scheme; host: string; base: string;
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

proc validate_CustomDomainsDelete_575229(path: JsonNode; query: JsonNode;
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
  var valid_575231 = path.getOrDefault("resourceGroupName")
  valid_575231 = validateParameter(valid_575231, JString, required = true,
                                 default = nil)
  if valid_575231 != nil:
    section.add "resourceGroupName", valid_575231
  var valid_575232 = path.getOrDefault("subscriptionId")
  valid_575232 = validateParameter(valid_575232, JString, required = true,
                                 default = nil)
  if valid_575232 != nil:
    section.add "subscriptionId", valid_575232
  var valid_575233 = path.getOrDefault("customDomainName")
  valid_575233 = validateParameter(valid_575233, JString, required = true,
                                 default = nil)
  if valid_575233 != nil:
    section.add "customDomainName", valid_575233
  var valid_575234 = path.getOrDefault("profileName")
  valid_575234 = validateParameter(valid_575234, JString, required = true,
                                 default = nil)
  if valid_575234 != nil:
    section.add "profileName", valid_575234
  var valid_575235 = path.getOrDefault("endpointName")
  valid_575235 = validateParameter(valid_575235, JString, required = true,
                                 default = nil)
  if valid_575235 != nil:
    section.add "endpointName", valid_575235
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575236 = query.getOrDefault("api-version")
  valid_575236 = validateParameter(valid_575236, JString, required = true,
                                 default = nil)
  if valid_575236 != nil:
    section.add "api-version", valid_575236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575237: Call_CustomDomainsDelete_575228; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing custom domain within an endpoint.
  ## 
  let valid = call_575237.validator(path, query, header, formData, body)
  let scheme = call_575237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575237.url(scheme.get, call_575237.host, call_575237.base,
                         call_575237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575237, url, valid)

proc call*(call_575238: Call_CustomDomainsDelete_575228; resourceGroupName: string;
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
  var path_575239 = newJObject()
  var query_575240 = newJObject()
  add(path_575239, "resourceGroupName", newJString(resourceGroupName))
  add(query_575240, "api-version", newJString(apiVersion))
  add(path_575239, "subscriptionId", newJString(subscriptionId))
  add(path_575239, "customDomainName", newJString(customDomainName))
  add(path_575239, "profileName", newJString(profileName))
  add(path_575239, "endpointName", newJString(endpointName))
  result = call_575238.call(path_575239, query_575240, nil, nil, nil)

var customDomainsDelete* = Call_CustomDomainsDelete_575228(
    name: "customDomainsDelete", meth: HttpMethod.HttpDelete,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/customDomains/{customDomainName}",
    validator: validate_CustomDomainsDelete_575229, base: "",
    url: url_CustomDomainsDelete_575230, schemes: {Scheme.Https})
type
  Call_CustomDomainsDisableCustomHttps_575241 = ref object of OpenApiRestCall_574467
proc url_CustomDomainsDisableCustomHttps_575243(protocol: Scheme; host: string;
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

proc validate_CustomDomainsDisableCustomHttps_575242(path: JsonNode;
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
  var valid_575244 = path.getOrDefault("resourceGroupName")
  valid_575244 = validateParameter(valid_575244, JString, required = true,
                                 default = nil)
  if valid_575244 != nil:
    section.add "resourceGroupName", valid_575244
  var valid_575245 = path.getOrDefault("subscriptionId")
  valid_575245 = validateParameter(valid_575245, JString, required = true,
                                 default = nil)
  if valid_575245 != nil:
    section.add "subscriptionId", valid_575245
  var valid_575246 = path.getOrDefault("customDomainName")
  valid_575246 = validateParameter(valid_575246, JString, required = true,
                                 default = nil)
  if valid_575246 != nil:
    section.add "customDomainName", valid_575246
  var valid_575247 = path.getOrDefault("profileName")
  valid_575247 = validateParameter(valid_575247, JString, required = true,
                                 default = nil)
  if valid_575247 != nil:
    section.add "profileName", valid_575247
  var valid_575248 = path.getOrDefault("endpointName")
  valid_575248 = validateParameter(valid_575248, JString, required = true,
                                 default = nil)
  if valid_575248 != nil:
    section.add "endpointName", valid_575248
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575249 = query.getOrDefault("api-version")
  valid_575249 = validateParameter(valid_575249, JString, required = true,
                                 default = nil)
  if valid_575249 != nil:
    section.add "api-version", valid_575249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575250: Call_CustomDomainsDisableCustomHttps_575241;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Disable https delivery of the custom domain.
  ## 
  let valid = call_575250.validator(path, query, header, formData, body)
  let scheme = call_575250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575250.url(scheme.get, call_575250.host, call_575250.base,
                         call_575250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575250, url, valid)

proc call*(call_575251: Call_CustomDomainsDisableCustomHttps_575241;
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
  var path_575252 = newJObject()
  var query_575253 = newJObject()
  add(path_575252, "resourceGroupName", newJString(resourceGroupName))
  add(query_575253, "api-version", newJString(apiVersion))
  add(path_575252, "subscriptionId", newJString(subscriptionId))
  add(path_575252, "customDomainName", newJString(customDomainName))
  add(path_575252, "profileName", newJString(profileName))
  add(path_575252, "endpointName", newJString(endpointName))
  result = call_575251.call(path_575252, query_575253, nil, nil, nil)

var customDomainsDisableCustomHttps* = Call_CustomDomainsDisableCustomHttps_575241(
    name: "customDomainsDisableCustomHttps", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/customDomains/{customDomainName}/disableCustomHttps",
    validator: validate_CustomDomainsDisableCustomHttps_575242, base: "",
    url: url_CustomDomainsDisableCustomHttps_575243, schemes: {Scheme.Https})
type
  Call_CustomDomainsEnableCustomHttps_575254 = ref object of OpenApiRestCall_574467
proc url_CustomDomainsEnableCustomHttps_575256(protocol: Scheme; host: string;
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

proc validate_CustomDomainsEnableCustomHttps_575255(path: JsonNode;
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
  var valid_575257 = path.getOrDefault("resourceGroupName")
  valid_575257 = validateParameter(valid_575257, JString, required = true,
                                 default = nil)
  if valid_575257 != nil:
    section.add "resourceGroupName", valid_575257
  var valid_575258 = path.getOrDefault("subscriptionId")
  valid_575258 = validateParameter(valid_575258, JString, required = true,
                                 default = nil)
  if valid_575258 != nil:
    section.add "subscriptionId", valid_575258
  var valid_575259 = path.getOrDefault("customDomainName")
  valid_575259 = validateParameter(valid_575259, JString, required = true,
                                 default = nil)
  if valid_575259 != nil:
    section.add "customDomainName", valid_575259
  var valid_575260 = path.getOrDefault("profileName")
  valid_575260 = validateParameter(valid_575260, JString, required = true,
                                 default = nil)
  if valid_575260 != nil:
    section.add "profileName", valid_575260
  var valid_575261 = path.getOrDefault("endpointName")
  valid_575261 = validateParameter(valid_575261, JString, required = true,
                                 default = nil)
  if valid_575261 != nil:
    section.add "endpointName", valid_575261
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575262 = query.getOrDefault("api-version")
  valid_575262 = validateParameter(valid_575262, JString, required = true,
                                 default = nil)
  if valid_575262 != nil:
    section.add "api-version", valid_575262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575263: Call_CustomDomainsEnableCustomHttps_575254; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Enable https delivery of the custom domain.
  ## 
  let valid = call_575263.validator(path, query, header, formData, body)
  let scheme = call_575263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575263.url(scheme.get, call_575263.host, call_575263.base,
                         call_575263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575263, url, valid)

proc call*(call_575264: Call_CustomDomainsEnableCustomHttps_575254;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          customDomainName: string; profileName: string; endpointName: string): Recallable =
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
  ##   endpointName: string (required)
  ##               : Name of the endpoint under the profile which is unique globally.
  var path_575265 = newJObject()
  var query_575266 = newJObject()
  add(path_575265, "resourceGroupName", newJString(resourceGroupName))
  add(query_575266, "api-version", newJString(apiVersion))
  add(path_575265, "subscriptionId", newJString(subscriptionId))
  add(path_575265, "customDomainName", newJString(customDomainName))
  add(path_575265, "profileName", newJString(profileName))
  add(path_575265, "endpointName", newJString(endpointName))
  result = call_575264.call(path_575265, query_575266, nil, nil, nil)

var customDomainsEnableCustomHttps* = Call_CustomDomainsEnableCustomHttps_575254(
    name: "customDomainsEnableCustomHttps", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/customDomains/{customDomainName}/enableCustomHttps",
    validator: validate_CustomDomainsEnableCustomHttps_575255, base: "",
    url: url_CustomDomainsEnableCustomHttps_575256, schemes: {Scheme.Https})
type
  Call_EndpointsLoadContent_575267 = ref object of OpenApiRestCall_574467
proc url_EndpointsLoadContent_575269(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsLoadContent_575268(path: JsonNode; query: JsonNode;
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
  var valid_575270 = path.getOrDefault("resourceGroupName")
  valid_575270 = validateParameter(valid_575270, JString, required = true,
                                 default = nil)
  if valid_575270 != nil:
    section.add "resourceGroupName", valid_575270
  var valid_575271 = path.getOrDefault("subscriptionId")
  valid_575271 = validateParameter(valid_575271, JString, required = true,
                                 default = nil)
  if valid_575271 != nil:
    section.add "subscriptionId", valid_575271
  var valid_575272 = path.getOrDefault("profileName")
  valid_575272 = validateParameter(valid_575272, JString, required = true,
                                 default = nil)
  if valid_575272 != nil:
    section.add "profileName", valid_575272
  var valid_575273 = path.getOrDefault("endpointName")
  valid_575273 = validateParameter(valid_575273, JString, required = true,
                                 default = nil)
  if valid_575273 != nil:
    section.add "endpointName", valid_575273
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575274 = query.getOrDefault("api-version")
  valid_575274 = validateParameter(valid_575274, JString, required = true,
                                 default = nil)
  if valid_575274 != nil:
    section.add "api-version", valid_575274
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

proc call*(call_575276: Call_EndpointsLoadContent_575267; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Pre-loads a content to CDN. Available for Verizon Profiles.
  ## 
  let valid = call_575276.validator(path, query, header, formData, body)
  let scheme = call_575276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575276.url(scheme.get, call_575276.host, call_575276.base,
                         call_575276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575276, url, valid)

proc call*(call_575277: Call_EndpointsLoadContent_575267;
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
  var path_575278 = newJObject()
  var query_575279 = newJObject()
  var body_575280 = newJObject()
  add(path_575278, "resourceGroupName", newJString(resourceGroupName))
  if contentFilePaths != nil:
    body_575280 = contentFilePaths
  add(query_575279, "api-version", newJString(apiVersion))
  add(path_575278, "subscriptionId", newJString(subscriptionId))
  add(path_575278, "profileName", newJString(profileName))
  add(path_575278, "endpointName", newJString(endpointName))
  result = call_575277.call(path_575278, query_575279, nil, nil, body_575280)

var endpointsLoadContent* = Call_EndpointsLoadContent_575267(
    name: "endpointsLoadContent", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/load",
    validator: validate_EndpointsLoadContent_575268, base: "",
    url: url_EndpointsLoadContent_575269, schemes: {Scheme.Https})
type
  Call_OriginsListByEndpoint_575281 = ref object of OpenApiRestCall_574467
proc url_OriginsListByEndpoint_575283(protocol: Scheme; host: string; base: string;
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

proc validate_OriginsListByEndpoint_575282(path: JsonNode; query: JsonNode;
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
  var valid_575284 = path.getOrDefault("resourceGroupName")
  valid_575284 = validateParameter(valid_575284, JString, required = true,
                                 default = nil)
  if valid_575284 != nil:
    section.add "resourceGroupName", valid_575284
  var valid_575285 = path.getOrDefault("subscriptionId")
  valid_575285 = validateParameter(valid_575285, JString, required = true,
                                 default = nil)
  if valid_575285 != nil:
    section.add "subscriptionId", valid_575285
  var valid_575286 = path.getOrDefault("profileName")
  valid_575286 = validateParameter(valid_575286, JString, required = true,
                                 default = nil)
  if valid_575286 != nil:
    section.add "profileName", valid_575286
  var valid_575287 = path.getOrDefault("endpointName")
  valid_575287 = validateParameter(valid_575287, JString, required = true,
                                 default = nil)
  if valid_575287 != nil:
    section.add "endpointName", valid_575287
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575288 = query.getOrDefault("api-version")
  valid_575288 = validateParameter(valid_575288, JString, required = true,
                                 default = nil)
  if valid_575288 != nil:
    section.add "api-version", valid_575288
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575289: Call_OriginsListByEndpoint_575281; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the existing origins within an endpoint.
  ## 
  let valid = call_575289.validator(path, query, header, formData, body)
  let scheme = call_575289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575289.url(scheme.get, call_575289.host, call_575289.base,
                         call_575289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575289, url, valid)

proc call*(call_575290: Call_OriginsListByEndpoint_575281;
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
  var path_575291 = newJObject()
  var query_575292 = newJObject()
  add(path_575291, "resourceGroupName", newJString(resourceGroupName))
  add(query_575292, "api-version", newJString(apiVersion))
  add(path_575291, "subscriptionId", newJString(subscriptionId))
  add(path_575291, "profileName", newJString(profileName))
  add(path_575291, "endpointName", newJString(endpointName))
  result = call_575290.call(path_575291, query_575292, nil, nil, nil)

var originsListByEndpoint* = Call_OriginsListByEndpoint_575281(
    name: "originsListByEndpoint", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/origins",
    validator: validate_OriginsListByEndpoint_575282, base: "",
    url: url_OriginsListByEndpoint_575283, schemes: {Scheme.Https})
type
  Call_OriginsGet_575293 = ref object of OpenApiRestCall_574467
proc url_OriginsGet_575295(protocol: Scheme; host: string; base: string; route: string;
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

proc validate_OriginsGet_575294(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_575296 = path.getOrDefault("resourceGroupName")
  valid_575296 = validateParameter(valid_575296, JString, required = true,
                                 default = nil)
  if valid_575296 != nil:
    section.add "resourceGroupName", valid_575296
  var valid_575297 = path.getOrDefault("originName")
  valid_575297 = validateParameter(valid_575297, JString, required = true,
                                 default = nil)
  if valid_575297 != nil:
    section.add "originName", valid_575297
  var valid_575298 = path.getOrDefault("subscriptionId")
  valid_575298 = validateParameter(valid_575298, JString, required = true,
                                 default = nil)
  if valid_575298 != nil:
    section.add "subscriptionId", valid_575298
  var valid_575299 = path.getOrDefault("profileName")
  valid_575299 = validateParameter(valid_575299, JString, required = true,
                                 default = nil)
  if valid_575299 != nil:
    section.add "profileName", valid_575299
  var valid_575300 = path.getOrDefault("endpointName")
  valid_575300 = validateParameter(valid_575300, JString, required = true,
                                 default = nil)
  if valid_575300 != nil:
    section.add "endpointName", valid_575300
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575301 = query.getOrDefault("api-version")
  valid_575301 = validateParameter(valid_575301, JString, required = true,
                                 default = nil)
  if valid_575301 != nil:
    section.add "api-version", valid_575301
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575302: Call_OriginsGet_575293; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an existing origin within an endpoint.
  ## 
  let valid = call_575302.validator(path, query, header, formData, body)
  let scheme = call_575302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575302.url(scheme.get, call_575302.host, call_575302.base,
                         call_575302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575302, url, valid)

proc call*(call_575303: Call_OriginsGet_575293; resourceGroupName: string;
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
  var path_575304 = newJObject()
  var query_575305 = newJObject()
  add(path_575304, "resourceGroupName", newJString(resourceGroupName))
  add(query_575305, "api-version", newJString(apiVersion))
  add(path_575304, "originName", newJString(originName))
  add(path_575304, "subscriptionId", newJString(subscriptionId))
  add(path_575304, "profileName", newJString(profileName))
  add(path_575304, "endpointName", newJString(endpointName))
  result = call_575303.call(path_575304, query_575305, nil, nil, nil)

var originsGet* = Call_OriginsGet_575293(name: "originsGet",
                                      meth: HttpMethod.HttpGet,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/origins/{originName}",
                                      validator: validate_OriginsGet_575294,
                                      base: "", url: url_OriginsGet_575295,
                                      schemes: {Scheme.Https})
type
  Call_OriginsUpdate_575306 = ref object of OpenApiRestCall_574467
proc url_OriginsUpdate_575308(protocol: Scheme; host: string; base: string;
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

proc validate_OriginsUpdate_575307(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_575309 = path.getOrDefault("resourceGroupName")
  valid_575309 = validateParameter(valid_575309, JString, required = true,
                                 default = nil)
  if valid_575309 != nil:
    section.add "resourceGroupName", valid_575309
  var valid_575310 = path.getOrDefault("originName")
  valid_575310 = validateParameter(valid_575310, JString, required = true,
                                 default = nil)
  if valid_575310 != nil:
    section.add "originName", valid_575310
  var valid_575311 = path.getOrDefault("subscriptionId")
  valid_575311 = validateParameter(valid_575311, JString, required = true,
                                 default = nil)
  if valid_575311 != nil:
    section.add "subscriptionId", valid_575311
  var valid_575312 = path.getOrDefault("profileName")
  valid_575312 = validateParameter(valid_575312, JString, required = true,
                                 default = nil)
  if valid_575312 != nil:
    section.add "profileName", valid_575312
  var valid_575313 = path.getOrDefault("endpointName")
  valid_575313 = validateParameter(valid_575313, JString, required = true,
                                 default = nil)
  if valid_575313 != nil:
    section.add "endpointName", valid_575313
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575314 = query.getOrDefault("api-version")
  valid_575314 = validateParameter(valid_575314, JString, required = true,
                                 default = nil)
  if valid_575314 != nil:
    section.add "api-version", valid_575314
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

proc call*(call_575316: Call_OriginsUpdate_575306; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing origin within an endpoint.
  ## 
  let valid = call_575316.validator(path, query, header, formData, body)
  let scheme = call_575316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575316.url(scheme.get, call_575316.host, call_575316.base,
                         call_575316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575316, url, valid)

proc call*(call_575317: Call_OriginsUpdate_575306;
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
  var path_575318 = newJObject()
  var query_575319 = newJObject()
  var body_575320 = newJObject()
  if originUpdateProperties != nil:
    body_575320 = originUpdateProperties
  add(path_575318, "resourceGroupName", newJString(resourceGroupName))
  add(query_575319, "api-version", newJString(apiVersion))
  add(path_575318, "originName", newJString(originName))
  add(path_575318, "subscriptionId", newJString(subscriptionId))
  add(path_575318, "profileName", newJString(profileName))
  add(path_575318, "endpointName", newJString(endpointName))
  result = call_575317.call(path_575318, query_575319, nil, nil, body_575320)

var originsUpdate* = Call_OriginsUpdate_575306(name: "originsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/origins/{originName}",
    validator: validate_OriginsUpdate_575307, base: "", url: url_OriginsUpdate_575308,
    schemes: {Scheme.Https})
type
  Call_EndpointsPurgeContent_575321 = ref object of OpenApiRestCall_574467
proc url_EndpointsPurgeContent_575323(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsPurgeContent_575322(path: JsonNode; query: JsonNode;
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
  var valid_575324 = path.getOrDefault("resourceGroupName")
  valid_575324 = validateParameter(valid_575324, JString, required = true,
                                 default = nil)
  if valid_575324 != nil:
    section.add "resourceGroupName", valid_575324
  var valid_575325 = path.getOrDefault("subscriptionId")
  valid_575325 = validateParameter(valid_575325, JString, required = true,
                                 default = nil)
  if valid_575325 != nil:
    section.add "subscriptionId", valid_575325
  var valid_575326 = path.getOrDefault("profileName")
  valid_575326 = validateParameter(valid_575326, JString, required = true,
                                 default = nil)
  if valid_575326 != nil:
    section.add "profileName", valid_575326
  var valid_575327 = path.getOrDefault("endpointName")
  valid_575327 = validateParameter(valid_575327, JString, required = true,
                                 default = nil)
  if valid_575327 != nil:
    section.add "endpointName", valid_575327
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575328 = query.getOrDefault("api-version")
  valid_575328 = validateParameter(valid_575328, JString, required = true,
                                 default = nil)
  if valid_575328 != nil:
    section.add "api-version", valid_575328
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

proc call*(call_575330: Call_EndpointsPurgeContent_575321; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Removes a content from CDN.
  ## 
  let valid = call_575330.validator(path, query, header, formData, body)
  let scheme = call_575330.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575330.url(scheme.get, call_575330.host, call_575330.base,
                         call_575330.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575330, url, valid)

proc call*(call_575331: Call_EndpointsPurgeContent_575321;
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
  var path_575332 = newJObject()
  var query_575333 = newJObject()
  var body_575334 = newJObject()
  add(path_575332, "resourceGroupName", newJString(resourceGroupName))
  if contentFilePaths != nil:
    body_575334 = contentFilePaths
  add(query_575333, "api-version", newJString(apiVersion))
  add(path_575332, "subscriptionId", newJString(subscriptionId))
  add(path_575332, "profileName", newJString(profileName))
  add(path_575332, "endpointName", newJString(endpointName))
  result = call_575331.call(path_575332, query_575333, nil, nil, body_575334)

var endpointsPurgeContent* = Call_EndpointsPurgeContent_575321(
    name: "endpointsPurgeContent", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/purge",
    validator: validate_EndpointsPurgeContent_575322, base: "",
    url: url_EndpointsPurgeContent_575323, schemes: {Scheme.Https})
type
  Call_EndpointsStart_575335 = ref object of OpenApiRestCall_574467
proc url_EndpointsStart_575337(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsStart_575336(path: JsonNode; query: JsonNode;
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
  var valid_575338 = path.getOrDefault("resourceGroupName")
  valid_575338 = validateParameter(valid_575338, JString, required = true,
                                 default = nil)
  if valid_575338 != nil:
    section.add "resourceGroupName", valid_575338
  var valid_575339 = path.getOrDefault("subscriptionId")
  valid_575339 = validateParameter(valid_575339, JString, required = true,
                                 default = nil)
  if valid_575339 != nil:
    section.add "subscriptionId", valid_575339
  var valid_575340 = path.getOrDefault("profileName")
  valid_575340 = validateParameter(valid_575340, JString, required = true,
                                 default = nil)
  if valid_575340 != nil:
    section.add "profileName", valid_575340
  var valid_575341 = path.getOrDefault("endpointName")
  valid_575341 = validateParameter(valid_575341, JString, required = true,
                                 default = nil)
  if valid_575341 != nil:
    section.add "endpointName", valid_575341
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575342 = query.getOrDefault("api-version")
  valid_575342 = validateParameter(valid_575342, JString, required = true,
                                 default = nil)
  if valid_575342 != nil:
    section.add "api-version", valid_575342
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575343: Call_EndpointsStart_575335; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts an existing CDN endpoint that is on a stopped state.
  ## 
  let valid = call_575343.validator(path, query, header, formData, body)
  let scheme = call_575343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575343.url(scheme.get, call_575343.host, call_575343.base,
                         call_575343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575343, url, valid)

proc call*(call_575344: Call_EndpointsStart_575335; resourceGroupName: string;
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
  var path_575345 = newJObject()
  var query_575346 = newJObject()
  add(path_575345, "resourceGroupName", newJString(resourceGroupName))
  add(query_575346, "api-version", newJString(apiVersion))
  add(path_575345, "subscriptionId", newJString(subscriptionId))
  add(path_575345, "profileName", newJString(profileName))
  add(path_575345, "endpointName", newJString(endpointName))
  result = call_575344.call(path_575345, query_575346, nil, nil, nil)

var endpointsStart* = Call_EndpointsStart_575335(name: "endpointsStart",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/start",
    validator: validate_EndpointsStart_575336, base: "", url: url_EndpointsStart_575337,
    schemes: {Scheme.Https})
type
  Call_EndpointsStop_575347 = ref object of OpenApiRestCall_574467
proc url_EndpointsStop_575349(protocol: Scheme; host: string; base: string;
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

proc validate_EndpointsStop_575348(path: JsonNode; query: JsonNode; header: JsonNode;
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
  var valid_575350 = path.getOrDefault("resourceGroupName")
  valid_575350 = validateParameter(valid_575350, JString, required = true,
                                 default = nil)
  if valid_575350 != nil:
    section.add "resourceGroupName", valid_575350
  var valid_575351 = path.getOrDefault("subscriptionId")
  valid_575351 = validateParameter(valid_575351, JString, required = true,
                                 default = nil)
  if valid_575351 != nil:
    section.add "subscriptionId", valid_575351
  var valid_575352 = path.getOrDefault("profileName")
  valid_575352 = validateParameter(valid_575352, JString, required = true,
                                 default = nil)
  if valid_575352 != nil:
    section.add "profileName", valid_575352
  var valid_575353 = path.getOrDefault("endpointName")
  valid_575353 = validateParameter(valid_575353, JString, required = true,
                                 default = nil)
  if valid_575353 != nil:
    section.add "endpointName", valid_575353
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575354 = query.getOrDefault("api-version")
  valid_575354 = validateParameter(valid_575354, JString, required = true,
                                 default = nil)
  if valid_575354 != nil:
    section.add "api-version", valid_575354
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575355: Call_EndpointsStop_575347; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stops an existing running CDN endpoint.
  ## 
  let valid = call_575355.validator(path, query, header, formData, body)
  let scheme = call_575355.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575355.url(scheme.get, call_575355.host, call_575355.base,
                         call_575355.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575355, url, valid)

proc call*(call_575356: Call_EndpointsStop_575347; resourceGroupName: string;
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
  var path_575357 = newJObject()
  var query_575358 = newJObject()
  add(path_575357, "resourceGroupName", newJString(resourceGroupName))
  add(query_575358, "api-version", newJString(apiVersion))
  add(path_575357, "subscriptionId", newJString(subscriptionId))
  add(path_575357, "profileName", newJString(profileName))
  add(path_575357, "endpointName", newJString(endpointName))
  result = call_575356.call(path_575357, query_575358, nil, nil, nil)

var endpointsStop* = Call_EndpointsStop_575347(name: "endpointsStop",
    meth: HttpMethod.HttpPost, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/stop",
    validator: validate_EndpointsStop_575348, base: "", url: url_EndpointsStop_575349,
    schemes: {Scheme.Https})
type
  Call_EndpointsValidateCustomDomain_575359 = ref object of OpenApiRestCall_574467
proc url_EndpointsValidateCustomDomain_575361(protocol: Scheme; host: string;
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

proc validate_EndpointsValidateCustomDomain_575360(path: JsonNode; query: JsonNode;
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
  var valid_575362 = path.getOrDefault("resourceGroupName")
  valid_575362 = validateParameter(valid_575362, JString, required = true,
                                 default = nil)
  if valid_575362 != nil:
    section.add "resourceGroupName", valid_575362
  var valid_575363 = path.getOrDefault("subscriptionId")
  valid_575363 = validateParameter(valid_575363, JString, required = true,
                                 default = nil)
  if valid_575363 != nil:
    section.add "subscriptionId", valid_575363
  var valid_575364 = path.getOrDefault("profileName")
  valid_575364 = validateParameter(valid_575364, JString, required = true,
                                 default = nil)
  if valid_575364 != nil:
    section.add "profileName", valid_575364
  var valid_575365 = path.getOrDefault("endpointName")
  valid_575365 = validateParameter(valid_575365, JString, required = true,
                                 default = nil)
  if valid_575365 != nil:
    section.add "endpointName", valid_575365
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575366 = query.getOrDefault("api-version")
  valid_575366 = validateParameter(valid_575366, JString, required = true,
                                 default = nil)
  if valid_575366 != nil:
    section.add "api-version", valid_575366
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

proc call*(call_575368: Call_EndpointsValidateCustomDomain_575359; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Validates the custom domain mapping to ensure it maps to the correct CDN endpoint in DNS.
  ## 
  let valid = call_575368.validator(path, query, header, formData, body)
  let scheme = call_575368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575368.url(scheme.get, call_575368.host, call_575368.base,
                         call_575368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575368, url, valid)

proc call*(call_575369: Call_EndpointsValidateCustomDomain_575359;
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
  var path_575370 = newJObject()
  var query_575371 = newJObject()
  var body_575372 = newJObject()
  add(path_575370, "resourceGroupName", newJString(resourceGroupName))
  add(query_575371, "api-version", newJString(apiVersion))
  if customDomainProperties != nil:
    body_575372 = customDomainProperties
  add(path_575370, "subscriptionId", newJString(subscriptionId))
  add(path_575370, "profileName", newJString(profileName))
  add(path_575370, "endpointName", newJString(endpointName))
  result = call_575369.call(path_575370, query_575371, nil, nil, body_575372)

var endpointsValidateCustomDomain* = Call_EndpointsValidateCustomDomain_575359(
    name: "endpointsValidateCustomDomain", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/endpoints/{endpointName}/validateCustomDomain",
    validator: validate_EndpointsValidateCustomDomain_575360, base: "",
    url: url_EndpointsValidateCustomDomain_575361, schemes: {Scheme.Https})
type
  Call_ProfilesGenerateSsoUri_575373 = ref object of OpenApiRestCall_574467
proc url_ProfilesGenerateSsoUri_575375(protocol: Scheme; host: string; base: string;
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

proc validate_ProfilesGenerateSsoUri_575374(path: JsonNode; query: JsonNode;
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
  var valid_575376 = path.getOrDefault("resourceGroupName")
  valid_575376 = validateParameter(valid_575376, JString, required = true,
                                 default = nil)
  if valid_575376 != nil:
    section.add "resourceGroupName", valid_575376
  var valid_575377 = path.getOrDefault("subscriptionId")
  valid_575377 = validateParameter(valid_575377, JString, required = true,
                                 default = nil)
  if valid_575377 != nil:
    section.add "subscriptionId", valid_575377
  var valid_575378 = path.getOrDefault("profileName")
  valid_575378 = validateParameter(valid_575378, JString, required = true,
                                 default = nil)
  if valid_575378 != nil:
    section.add "profileName", valid_575378
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575379 = query.getOrDefault("api-version")
  valid_575379 = validateParameter(valid_575379, JString, required = true,
                                 default = nil)
  if valid_575379 != nil:
    section.add "api-version", valid_575379
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575380: Call_ProfilesGenerateSsoUri_575373; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Generates a dynamic SSO URI used to sign in to the CDN supplemental portal. Supplemental portal is used to configure advanced feature capabilities that are not yet available in the Azure portal, such as core reports in a standard profile; rules engine, advanced HTTP reports, and real-time stats and alerts in a premium profile. The SSO URI changes approximately every 10 minutes.
  ## 
  let valid = call_575380.validator(path, query, header, formData, body)
  let scheme = call_575380.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575380.url(scheme.get, call_575380.host, call_575380.base,
                         call_575380.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575380, url, valid)

proc call*(call_575381: Call_ProfilesGenerateSsoUri_575373;
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
  var path_575382 = newJObject()
  var query_575383 = newJObject()
  add(path_575382, "resourceGroupName", newJString(resourceGroupName))
  add(query_575383, "api-version", newJString(apiVersion))
  add(path_575382, "subscriptionId", newJString(subscriptionId))
  add(path_575382, "profileName", newJString(profileName))
  result = call_575381.call(path_575382, query_575383, nil, nil, nil)

var profilesGenerateSsoUri* = Call_ProfilesGenerateSsoUri_575373(
    name: "profilesGenerateSsoUri", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/generateSsoUri",
    validator: validate_ProfilesGenerateSsoUri_575374, base: "",
    url: url_ProfilesGenerateSsoUri_575375, schemes: {Scheme.Https})
type
  Call_ProfilesListSupportedOptimizationTypes_575384 = ref object of OpenApiRestCall_574467
proc url_ProfilesListSupportedOptimizationTypes_575386(protocol: Scheme;
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

proc validate_ProfilesListSupportedOptimizationTypes_575385(path: JsonNode;
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
  var valid_575387 = path.getOrDefault("resourceGroupName")
  valid_575387 = validateParameter(valid_575387, JString, required = true,
                                 default = nil)
  if valid_575387 != nil:
    section.add "resourceGroupName", valid_575387
  var valid_575388 = path.getOrDefault("subscriptionId")
  valid_575388 = validateParameter(valid_575388, JString, required = true,
                                 default = nil)
  if valid_575388 != nil:
    section.add "subscriptionId", valid_575388
  var valid_575389 = path.getOrDefault("profileName")
  valid_575389 = validateParameter(valid_575389, JString, required = true,
                                 default = nil)
  if valid_575389 != nil:
    section.add "profileName", valid_575389
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Version of the API to be used with the client request. Current version is 2017-04-02.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_575390 = query.getOrDefault("api-version")
  valid_575390 = validateParameter(valid_575390, JString, required = true,
                                 default = nil)
  if valid_575390 != nil:
    section.add "api-version", valid_575390
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_575391: Call_ProfilesListSupportedOptimizationTypes_575384;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the supported optimization types for the current profile. A user can create an endpoint with an optimization type from the listed values.
  ## 
  let valid = call_575391.validator(path, query, header, formData, body)
  let scheme = call_575391.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_575391.url(scheme.get, call_575391.host, call_575391.base,
                         call_575391.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_575391, url, valid)

proc call*(call_575392: Call_ProfilesListSupportedOptimizationTypes_575384;
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
  var path_575393 = newJObject()
  var query_575394 = newJObject()
  add(path_575393, "resourceGroupName", newJString(resourceGroupName))
  add(query_575394, "api-version", newJString(apiVersion))
  add(path_575393, "subscriptionId", newJString(subscriptionId))
  add(path_575393, "profileName", newJString(profileName))
  result = call_575392.call(path_575393, query_575394, nil, nil, nil)

var profilesListSupportedOptimizationTypes* = Call_ProfilesListSupportedOptimizationTypes_575384(
    name: "profilesListSupportedOptimizationTypes", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cdn/profiles/{profileName}/getSupportedOptimizationTypes",
    validator: validate_ProfilesListSupportedOptimizationTypes_575385, base: "",
    url: url_ProfilesListSupportedOptimizationTypes_575386,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
