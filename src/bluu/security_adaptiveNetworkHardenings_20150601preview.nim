
import
  json, options, hashes, uri, rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Security Center
## version: 2015-06-01-preview
## termsOfService: (not provided)
## license: (not provided)
## 
## API spec for Microsoft.Security (Azure Security Center) resource provider
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

  OpenApiRestCall_567657 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_567657](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_567657): Option[Scheme] {.used.} =
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
  macServiceName = "security-adaptiveNetworkHardenings"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AdaptiveNetworkHardeningsListByExtendedResource_567879 = ref object of OpenApiRestCall_567657
proc url_AdaptiveNetworkHardeningsListByExtendedResource_567881(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceNamespace" in path,
        "`resourceNamespace` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/adaptiveNetworkHardenings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdaptiveNetworkHardeningsListByExtendedResource_567880(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets a list of Adaptive Network Hardenings resources in scope of an extended resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The type of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  ##   resourceNamespace: JString (required)
  ##                    : The Namespace of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568041 = path.getOrDefault("resourceType")
  valid_568041 = validateParameter(valid_568041, JString, required = true,
                                 default = nil)
  if valid_568041 != nil:
    section.add "resourceType", valid_568041
  var valid_568042 = path.getOrDefault("resourceGroupName")
  valid_568042 = validateParameter(valid_568042, JString, required = true,
                                 default = nil)
  if valid_568042 != nil:
    section.add "resourceGroupName", valid_568042
  var valid_568043 = path.getOrDefault("subscriptionId")
  valid_568043 = validateParameter(valid_568043, JString, required = true,
                                 default = nil)
  if valid_568043 != nil:
    section.add "subscriptionId", valid_568043
  var valid_568044 = path.getOrDefault("resourceName")
  valid_568044 = validateParameter(valid_568044, JString, required = true,
                                 default = nil)
  if valid_568044 != nil:
    section.add "resourceName", valid_568044
  var valid_568045 = path.getOrDefault("resourceNamespace")
  valid_568045 = validateParameter(valid_568045, JString, required = true,
                                 default = nil)
  if valid_568045 != nil:
    section.add "resourceNamespace", valid_568045
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568046 = query.getOrDefault("api-version")
  valid_568046 = validateParameter(valid_568046, JString, required = true,
                                 default = nil)
  if valid_568046 != nil:
    section.add "api-version", valid_568046
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568073: Call_AdaptiveNetworkHardeningsListByExtendedResource_567879;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of Adaptive Network Hardenings resources in scope of an extended resource.
  ## 
  let valid = call_568073.validator(path, query, header, formData, body)
  let scheme = call_568073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568073.url(scheme.get, call_568073.host, call_568073.base,
                         call_568073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568073, url, valid)

proc call*(call_568144: Call_AdaptiveNetworkHardeningsListByExtendedResource_567879;
          resourceType: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string; resourceNamespace: string): Recallable =
  ## adaptiveNetworkHardeningsListByExtendedResource
  ## Gets a list of Adaptive Network Hardenings resources in scope of an extended resource.
  ##   resourceType: string (required)
  ##               : The type of the resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   resourceName: string (required)
  ##               : Name of the resource.
  ##   resourceNamespace: string (required)
  ##                    : The Namespace of the resource.
  var path_568145 = newJObject()
  var query_568147 = newJObject()
  add(path_568145, "resourceType", newJString(resourceType))
  add(path_568145, "resourceGroupName", newJString(resourceGroupName))
  add(query_568147, "api-version", newJString(apiVersion))
  add(path_568145, "subscriptionId", newJString(subscriptionId))
  add(path_568145, "resourceName", newJString(resourceName))
  add(path_568145, "resourceNamespace", newJString(resourceNamespace))
  result = call_568144.call(path_568145, query_568147, nil, nil, nil)

var adaptiveNetworkHardeningsListByExtendedResource* = Call_AdaptiveNetworkHardeningsListByExtendedResource_567879(
    name: "adaptiveNetworkHardeningsListByExtendedResource",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceNamespace}/{resourceType}/{resourceName}/providers/Microsoft.Security/adaptiveNetworkHardenings",
    validator: validate_AdaptiveNetworkHardeningsListByExtendedResource_567880,
    base: "", url: url_AdaptiveNetworkHardeningsListByExtendedResource_567881,
    schemes: {Scheme.Https})
type
  Call_AdaptiveNetworkHardeningsGet_568186 = ref object of OpenApiRestCall_567657
proc url_AdaptiveNetworkHardeningsGet_568188(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceNamespace" in path,
        "`resourceNamespace` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "adaptiveNetworkHardeningResourceName" in path,
        "`adaptiveNetworkHardeningResourceName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/adaptiveNetworkHardenings/"), (
        kind: VariableSegment, value: "adaptiveNetworkHardeningResourceName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdaptiveNetworkHardeningsGet_568187(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a single Adaptive Network Hardening resource
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The type of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  ##   resourceNamespace: JString (required)
  ##                    : The Namespace of the resource.
  ##   adaptiveNetworkHardeningResourceName: JString (required)
  ##                                       : The name of the Adaptive Network Hardening resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568198 = path.getOrDefault("resourceType")
  valid_568198 = validateParameter(valid_568198, JString, required = true,
                                 default = nil)
  if valid_568198 != nil:
    section.add "resourceType", valid_568198
  var valid_568199 = path.getOrDefault("resourceGroupName")
  valid_568199 = validateParameter(valid_568199, JString, required = true,
                                 default = nil)
  if valid_568199 != nil:
    section.add "resourceGroupName", valid_568199
  var valid_568200 = path.getOrDefault("subscriptionId")
  valid_568200 = validateParameter(valid_568200, JString, required = true,
                                 default = nil)
  if valid_568200 != nil:
    section.add "subscriptionId", valid_568200
  var valid_568201 = path.getOrDefault("resourceName")
  valid_568201 = validateParameter(valid_568201, JString, required = true,
                                 default = nil)
  if valid_568201 != nil:
    section.add "resourceName", valid_568201
  var valid_568202 = path.getOrDefault("resourceNamespace")
  valid_568202 = validateParameter(valid_568202, JString, required = true,
                                 default = nil)
  if valid_568202 != nil:
    section.add "resourceNamespace", valid_568202
  var valid_568203 = path.getOrDefault("adaptiveNetworkHardeningResourceName")
  valid_568203 = validateParameter(valid_568203, JString, required = true,
                                 default = nil)
  if valid_568203 != nil:
    section.add "adaptiveNetworkHardeningResourceName", valid_568203
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568204 = query.getOrDefault("api-version")
  valid_568204 = validateParameter(valid_568204, JString, required = true,
                                 default = nil)
  if valid_568204 != nil:
    section.add "api-version", valid_568204
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_568205: Call_AdaptiveNetworkHardeningsGet_568186; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a single Adaptive Network Hardening resource
  ## 
  let valid = call_568205.validator(path, query, header, formData, body)
  let scheme = call_568205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568205.url(scheme.get, call_568205.host, call_568205.base,
                         call_568205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568205, url, valid)

proc call*(call_568206: Call_AdaptiveNetworkHardeningsGet_568186;
          resourceType: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string; resourceNamespace: string;
          adaptiveNetworkHardeningResourceName: string): Recallable =
  ## adaptiveNetworkHardeningsGet
  ## Gets a single Adaptive Network Hardening resource
  ##   resourceType: string (required)
  ##               : The type of the resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   resourceName: string (required)
  ##               : Name of the resource.
  ##   resourceNamespace: string (required)
  ##                    : The Namespace of the resource.
  ##   adaptiveNetworkHardeningResourceName: string (required)
  ##                                       : The name of the Adaptive Network Hardening resource.
  var path_568207 = newJObject()
  var query_568208 = newJObject()
  add(path_568207, "resourceType", newJString(resourceType))
  add(path_568207, "resourceGroupName", newJString(resourceGroupName))
  add(query_568208, "api-version", newJString(apiVersion))
  add(path_568207, "subscriptionId", newJString(subscriptionId))
  add(path_568207, "resourceName", newJString(resourceName))
  add(path_568207, "resourceNamespace", newJString(resourceNamespace))
  add(path_568207, "adaptiveNetworkHardeningResourceName",
      newJString(adaptiveNetworkHardeningResourceName))
  result = call_568206.call(path_568207, query_568208, nil, nil, nil)

var adaptiveNetworkHardeningsGet* = Call_AdaptiveNetworkHardeningsGet_568186(
    name: "adaptiveNetworkHardeningsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceNamespace}/{resourceType}/{resourceName}/providers/Microsoft.Security/adaptiveNetworkHardenings/{adaptiveNetworkHardeningResourceName}",
    validator: validate_AdaptiveNetworkHardeningsGet_568187, base: "",
    url: url_AdaptiveNetworkHardeningsGet_568188, schemes: {Scheme.Https})
type
  Call_AdaptiveNetworkHardeningsEnforce_568209 = ref object of OpenApiRestCall_567657
proc url_AdaptiveNetworkHardeningsEnforce_568211(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "resourceNamespace" in path,
        "`resourceNamespace` is a required path parameter"
  assert "resourceType" in path, "`resourceType` is a required path parameter"
  assert "resourceName" in path, "`resourceName` is a required path parameter"
  assert "adaptiveNetworkHardeningResourceName" in path,
        "`adaptiveNetworkHardeningResourceName` is a required path parameter"
  assert "adaptiveNetworkHardeningEnforceAction" in path,
        "`adaptiveNetworkHardeningEnforceAction` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourceGroups/"),
               (kind: VariableSegment, value: "resourceGroupName"),
               (kind: ConstantSegment, value: "/providers/"),
               (kind: VariableSegment, value: "resourceNamespace"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceType"),
               (kind: ConstantSegment, value: "/"),
               (kind: VariableSegment, value: "resourceName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.Security/adaptiveNetworkHardenings/"), (
        kind: VariableSegment, value: "adaptiveNetworkHardeningResourceName"),
               (kind: ConstantSegment, value: "/"), (kind: VariableSegment,
        value: "adaptiveNetworkHardeningEnforceAction")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AdaptiveNetworkHardeningsEnforce_568210(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Enforces the given rules on the NSG(s) listed in the request
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The type of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  ##   adaptiveNetworkHardeningEnforceAction: JString (required)
  ##                                        : Enforces the given rules on the NSG(s) listed in the request
  ##   resourceNamespace: JString (required)
  ##                    : The Namespace of the resource.
  ##   adaptiveNetworkHardeningResourceName: JString (required)
  ##                                       : The name of the Adaptive Network Hardening resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_568212 = path.getOrDefault("resourceType")
  valid_568212 = validateParameter(valid_568212, JString, required = true,
                                 default = nil)
  if valid_568212 != nil:
    section.add "resourceType", valid_568212
  var valid_568213 = path.getOrDefault("resourceGroupName")
  valid_568213 = validateParameter(valid_568213, JString, required = true,
                                 default = nil)
  if valid_568213 != nil:
    section.add "resourceGroupName", valid_568213
  var valid_568214 = path.getOrDefault("subscriptionId")
  valid_568214 = validateParameter(valid_568214, JString, required = true,
                                 default = nil)
  if valid_568214 != nil:
    section.add "subscriptionId", valid_568214
  var valid_568215 = path.getOrDefault("resourceName")
  valid_568215 = validateParameter(valid_568215, JString, required = true,
                                 default = nil)
  if valid_568215 != nil:
    section.add "resourceName", valid_568215
  var valid_568229 = path.getOrDefault("adaptiveNetworkHardeningEnforceAction")
  valid_568229 = validateParameter(valid_568229, JString, required = true,
                                 default = newJString("enforce"))
  if valid_568229 != nil:
    section.add "adaptiveNetworkHardeningEnforceAction", valid_568229
  var valid_568230 = path.getOrDefault("resourceNamespace")
  valid_568230 = validateParameter(valid_568230, JString, required = true,
                                 default = nil)
  if valid_568230 != nil:
    section.add "resourceNamespace", valid_568230
  var valid_568231 = path.getOrDefault("adaptiveNetworkHardeningResourceName")
  valid_568231 = validateParameter(valid_568231, JString, required = true,
                                 default = nil)
  if valid_568231 != nil:
    section.add "adaptiveNetworkHardeningResourceName", valid_568231
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_568232 = query.getOrDefault("api-version")
  valid_568232 = validateParameter(valid_568232, JString, required = true,
                                 default = nil)
  if valid_568232 != nil:
    section.add "api-version", valid_568232
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject (required)
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_568234: Call_AdaptiveNetworkHardeningsEnforce_568209;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enforces the given rules on the NSG(s) listed in the request
  ## 
  let valid = call_568234.validator(path, query, header, formData, body)
  let scheme = call_568234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_568234.url(scheme.get, call_568234.host, call_568234.base,
                         call_568234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_568234, url, valid)

proc call*(call_568235: Call_AdaptiveNetworkHardeningsEnforce_568209;
          resourceType: string; resourceGroupName: string; apiVersion: string;
          subscriptionId: string; resourceName: string; resourceNamespace: string;
          adaptiveNetworkHardeningResourceName: string; body: JsonNode;
          adaptiveNetworkHardeningEnforceAction: string = "enforce"): Recallable =
  ## adaptiveNetworkHardeningsEnforce
  ## Enforces the given rules on the NSG(s) listed in the request
  ##   resourceType: string (required)
  ##               : The type of the resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   resourceName: string (required)
  ##               : Name of the resource.
  ##   adaptiveNetworkHardeningEnforceAction: string (required)
  ##                                        : Enforces the given rules on the NSG(s) listed in the request
  ##   resourceNamespace: string (required)
  ##                    : The Namespace of the resource.
  ##   adaptiveNetworkHardeningResourceName: string (required)
  ##                                       : The name of the Adaptive Network Hardening resource.
  ##   body: JObject (required)
  var path_568236 = newJObject()
  var query_568237 = newJObject()
  var body_568238 = newJObject()
  add(path_568236, "resourceType", newJString(resourceType))
  add(path_568236, "resourceGroupName", newJString(resourceGroupName))
  add(query_568237, "api-version", newJString(apiVersion))
  add(path_568236, "subscriptionId", newJString(subscriptionId))
  add(path_568236, "resourceName", newJString(resourceName))
  add(path_568236, "adaptiveNetworkHardeningEnforceAction",
      newJString(adaptiveNetworkHardeningEnforceAction))
  add(path_568236, "resourceNamespace", newJString(resourceNamespace))
  add(path_568236, "adaptiveNetworkHardeningResourceName",
      newJString(adaptiveNetworkHardeningResourceName))
  if body != nil:
    body_568238 = body
  result = call_568235.call(path_568236, query_568237, nil, nil, body_568238)

var adaptiveNetworkHardeningsEnforce* = Call_AdaptiveNetworkHardeningsEnforce_568209(
    name: "adaptiveNetworkHardeningsEnforce", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceNamespace}/{resourceType}/{resourceName}/providers/Microsoft.Security/adaptiveNetworkHardenings/{adaptiveNetworkHardeningResourceName}/{adaptiveNetworkHardeningEnforceAction}",
    validator: validate_AdaptiveNetworkHardeningsEnforce_568210, base: "",
    url: url_AdaptiveNetworkHardeningsEnforce_568211, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
