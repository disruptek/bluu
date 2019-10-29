
import
  json, options, hashes, uri, rest, os, uri, httpcore

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
  macServiceName = "security-adaptiveNetworkHardenings"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AdaptiveNetworkHardeningsListByExtendedResource_563777 = ref object of OpenApiRestCall_563555
proc url_AdaptiveNetworkHardeningsListByExtendedResource_563779(protocol: Scheme;
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

proc validate_AdaptiveNetworkHardeningsListByExtendedResource_563778(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets a list of Adaptive Network Hardenings resources in scope of an extended resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The type of the resource.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   resourceNamespace: JString (required)
  ##                    : The Namespace of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_563941 = path.getOrDefault("resourceType")
  valid_563941 = validateParameter(valid_563941, JString, required = true,
                                 default = nil)
  if valid_563941 != nil:
    section.add "resourceType", valid_563941
  var valid_563942 = path.getOrDefault("subscriptionId")
  valid_563942 = validateParameter(valid_563942, JString, required = true,
                                 default = nil)
  if valid_563942 != nil:
    section.add "subscriptionId", valid_563942
  var valid_563943 = path.getOrDefault("resourceNamespace")
  valid_563943 = validateParameter(valid_563943, JString, required = true,
                                 default = nil)
  if valid_563943 != nil:
    section.add "resourceNamespace", valid_563943
  var valid_563944 = path.getOrDefault("resourceGroupName")
  valid_563944 = validateParameter(valid_563944, JString, required = true,
                                 default = nil)
  if valid_563944 != nil:
    section.add "resourceGroupName", valid_563944
  var valid_563945 = path.getOrDefault("resourceName")
  valid_563945 = validateParameter(valid_563945, JString, required = true,
                                 default = nil)
  if valid_563945 != nil:
    section.add "resourceName", valid_563945
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_563946 = query.getOrDefault("api-version")
  valid_563946 = validateParameter(valid_563946, JString, required = true,
                                 default = nil)
  if valid_563946 != nil:
    section.add "api-version", valid_563946
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_563973: Call_AdaptiveNetworkHardeningsListByExtendedResource_563777;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a list of Adaptive Network Hardenings resources in scope of an extended resource.
  ## 
  let valid = call_563973.validator(path, query, header, formData, body)
  let scheme = call_563973.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_563973.url(scheme.get, call_563973.host, call_563973.base,
                         call_563973.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_563973, url, valid)

proc call*(call_564044: Call_AdaptiveNetworkHardeningsListByExtendedResource_563777;
          apiVersion: string; resourceType: string; subscriptionId: string;
          resourceNamespace: string; resourceGroupName: string; resourceName: string): Recallable =
  ## adaptiveNetworkHardeningsListByExtendedResource
  ## Gets a list of Adaptive Network Hardenings resources in scope of an extended resource.
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   resourceType: string (required)
  ##               : The type of the resource.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   resourceNamespace: string (required)
  ##                    : The Namespace of the resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   resourceName: string (required)
  ##               : Name of the resource.
  var path_564045 = newJObject()
  var query_564047 = newJObject()
  add(query_564047, "api-version", newJString(apiVersion))
  add(path_564045, "resourceType", newJString(resourceType))
  add(path_564045, "subscriptionId", newJString(subscriptionId))
  add(path_564045, "resourceNamespace", newJString(resourceNamespace))
  add(path_564045, "resourceGroupName", newJString(resourceGroupName))
  add(path_564045, "resourceName", newJString(resourceName))
  result = call_564044.call(path_564045, query_564047, nil, nil, nil)

var adaptiveNetworkHardeningsListByExtendedResource* = Call_AdaptiveNetworkHardeningsListByExtendedResource_563777(
    name: "adaptiveNetworkHardeningsListByExtendedResource",
    meth: HttpMethod.HttpGet, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceNamespace}/{resourceType}/{resourceName}/providers/Microsoft.Security/adaptiveNetworkHardenings",
    validator: validate_AdaptiveNetworkHardeningsListByExtendedResource_563778,
    base: "", url: url_AdaptiveNetworkHardeningsListByExtendedResource_563779,
    schemes: {Scheme.Https})
type
  Call_AdaptiveNetworkHardeningsGet_564086 = ref object of OpenApiRestCall_563555
proc url_AdaptiveNetworkHardeningsGet_564088(protocol: Scheme; host: string;
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

proc validate_AdaptiveNetworkHardeningsGet_564087(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a single Adaptive Network Hardening resource
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The type of the resource.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   resourceNamespace: JString (required)
  ##                    : The Namespace of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   adaptiveNetworkHardeningResourceName: JString (required)
  ##                                       : The name of the Adaptive Network Hardening resource.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_564098 = path.getOrDefault("resourceType")
  valid_564098 = validateParameter(valid_564098, JString, required = true,
                                 default = nil)
  if valid_564098 != nil:
    section.add "resourceType", valid_564098
  var valid_564099 = path.getOrDefault("subscriptionId")
  valid_564099 = validateParameter(valid_564099, JString, required = true,
                                 default = nil)
  if valid_564099 != nil:
    section.add "subscriptionId", valid_564099
  var valid_564100 = path.getOrDefault("resourceNamespace")
  valid_564100 = validateParameter(valid_564100, JString, required = true,
                                 default = nil)
  if valid_564100 != nil:
    section.add "resourceNamespace", valid_564100
  var valid_564101 = path.getOrDefault("resourceGroupName")
  valid_564101 = validateParameter(valid_564101, JString, required = true,
                                 default = nil)
  if valid_564101 != nil:
    section.add "resourceGroupName", valid_564101
  var valid_564102 = path.getOrDefault("adaptiveNetworkHardeningResourceName")
  valid_564102 = validateParameter(valid_564102, JString, required = true,
                                 default = nil)
  if valid_564102 != nil:
    section.add "adaptiveNetworkHardeningResourceName", valid_564102
  var valid_564103 = path.getOrDefault("resourceName")
  valid_564103 = validateParameter(valid_564103, JString, required = true,
                                 default = nil)
  if valid_564103 != nil:
    section.add "resourceName", valid_564103
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564104 = query.getOrDefault("api-version")
  valid_564104 = validateParameter(valid_564104, JString, required = true,
                                 default = nil)
  if valid_564104 != nil:
    section.add "api-version", valid_564104
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_564105: Call_AdaptiveNetworkHardeningsGet_564086; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a single Adaptive Network Hardening resource
  ## 
  let valid = call_564105.validator(path, query, header, formData, body)
  let scheme = call_564105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564105.url(scheme.get, call_564105.host, call_564105.base,
                         call_564105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564105, url, valid)

proc call*(call_564106: Call_AdaptiveNetworkHardeningsGet_564086;
          apiVersion: string; resourceType: string; subscriptionId: string;
          resourceNamespace: string; resourceGroupName: string;
          adaptiveNetworkHardeningResourceName: string; resourceName: string): Recallable =
  ## adaptiveNetworkHardeningsGet
  ## Gets a single Adaptive Network Hardening resource
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   resourceType: string (required)
  ##               : The type of the resource.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   resourceNamespace: string (required)
  ##                    : The Namespace of the resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   adaptiveNetworkHardeningResourceName: string (required)
  ##                                       : The name of the Adaptive Network Hardening resource.
  ##   resourceName: string (required)
  ##               : Name of the resource.
  var path_564107 = newJObject()
  var query_564108 = newJObject()
  add(query_564108, "api-version", newJString(apiVersion))
  add(path_564107, "resourceType", newJString(resourceType))
  add(path_564107, "subscriptionId", newJString(subscriptionId))
  add(path_564107, "resourceNamespace", newJString(resourceNamespace))
  add(path_564107, "resourceGroupName", newJString(resourceGroupName))
  add(path_564107, "adaptiveNetworkHardeningResourceName",
      newJString(adaptiveNetworkHardeningResourceName))
  add(path_564107, "resourceName", newJString(resourceName))
  result = call_564106.call(path_564107, query_564108, nil, nil, nil)

var adaptiveNetworkHardeningsGet* = Call_AdaptiveNetworkHardeningsGet_564086(
    name: "adaptiveNetworkHardeningsGet", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceNamespace}/{resourceType}/{resourceName}/providers/Microsoft.Security/adaptiveNetworkHardenings/{adaptiveNetworkHardeningResourceName}",
    validator: validate_AdaptiveNetworkHardeningsGet_564087, base: "",
    url: url_AdaptiveNetworkHardeningsGet_564088, schemes: {Scheme.Https})
type
  Call_AdaptiveNetworkHardeningsEnforce_564109 = ref object of OpenApiRestCall_563555
proc url_AdaptiveNetworkHardeningsEnforce_564111(protocol: Scheme; host: string;
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

proc validate_AdaptiveNetworkHardeningsEnforce_564110(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Enforces the given rules on the NSG(s) listed in the request
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceType: JString (required)
  ##               : The type of the resource.
  ##   subscriptionId: JString (required)
  ##                 : Azure subscription ID
  ##   resourceNamespace: JString (required)
  ##                    : The Namespace of the resource.
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   adaptiveNetworkHardeningResourceName: JString (required)
  ##                                       : The name of the Adaptive Network Hardening resource.
  ##   resourceName: JString (required)
  ##               : Name of the resource.
  ##   adaptiveNetworkHardeningEnforceAction: JString (required)
  ##                                        : Enforces the given rules on the NSG(s) listed in the request
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceType` field"
  var valid_564112 = path.getOrDefault("resourceType")
  valid_564112 = validateParameter(valid_564112, JString, required = true,
                                 default = nil)
  if valid_564112 != nil:
    section.add "resourceType", valid_564112
  var valid_564113 = path.getOrDefault("subscriptionId")
  valid_564113 = validateParameter(valid_564113, JString, required = true,
                                 default = nil)
  if valid_564113 != nil:
    section.add "subscriptionId", valid_564113
  var valid_564114 = path.getOrDefault("resourceNamespace")
  valid_564114 = validateParameter(valid_564114, JString, required = true,
                                 default = nil)
  if valid_564114 != nil:
    section.add "resourceNamespace", valid_564114
  var valid_564115 = path.getOrDefault("resourceGroupName")
  valid_564115 = validateParameter(valid_564115, JString, required = true,
                                 default = nil)
  if valid_564115 != nil:
    section.add "resourceGroupName", valid_564115
  var valid_564116 = path.getOrDefault("adaptiveNetworkHardeningResourceName")
  valid_564116 = validateParameter(valid_564116, JString, required = true,
                                 default = nil)
  if valid_564116 != nil:
    section.add "adaptiveNetworkHardeningResourceName", valid_564116
  var valid_564117 = path.getOrDefault("resourceName")
  valid_564117 = validateParameter(valid_564117, JString, required = true,
                                 default = nil)
  if valid_564117 != nil:
    section.add "resourceName", valid_564117
  var valid_564131 = path.getOrDefault("adaptiveNetworkHardeningEnforceAction")
  valid_564131 = validateParameter(valid_564131, JString, required = true,
                                 default = newJString("enforce"))
  if valid_564131 != nil:
    section.add "adaptiveNetworkHardeningEnforceAction", valid_564131
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : API version for the operation
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_564132 = query.getOrDefault("api-version")
  valid_564132 = validateParameter(valid_564132, JString, required = true,
                                 default = nil)
  if valid_564132 != nil:
    section.add "api-version", valid_564132
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

proc call*(call_564134: Call_AdaptiveNetworkHardeningsEnforce_564109;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enforces the given rules on the NSG(s) listed in the request
  ## 
  let valid = call_564134.validator(path, query, header, formData, body)
  let scheme = call_564134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_564134.url(scheme.get, call_564134.host, call_564134.base,
                         call_564134.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_564134, url, valid)

proc call*(call_564135: Call_AdaptiveNetworkHardeningsEnforce_564109;
          apiVersion: string; resourceType: string; subscriptionId: string;
          resourceNamespace: string; resourceGroupName: string;
          adaptiveNetworkHardeningResourceName: string; body: JsonNode;
          resourceName: string;
          adaptiveNetworkHardeningEnforceAction: string = "enforce"): Recallable =
  ## adaptiveNetworkHardeningsEnforce
  ## Enforces the given rules on the NSG(s) listed in the request
  ##   apiVersion: string (required)
  ##             : API version for the operation
  ##   resourceType: string (required)
  ##               : The type of the resource.
  ##   subscriptionId: string (required)
  ##                 : Azure subscription ID
  ##   resourceNamespace: string (required)
  ##                    : The Namespace of the resource.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group within the user's subscription. The name is case insensitive.
  ##   adaptiveNetworkHardeningResourceName: string (required)
  ##                                       : The name of the Adaptive Network Hardening resource.
  ##   body: JObject (required)
  ##   resourceName: string (required)
  ##               : Name of the resource.
  ##   adaptiveNetworkHardeningEnforceAction: string (required)
  ##                                        : Enforces the given rules on the NSG(s) listed in the request
  var path_564136 = newJObject()
  var query_564137 = newJObject()
  var body_564138 = newJObject()
  add(query_564137, "api-version", newJString(apiVersion))
  add(path_564136, "resourceType", newJString(resourceType))
  add(path_564136, "subscriptionId", newJString(subscriptionId))
  add(path_564136, "resourceNamespace", newJString(resourceNamespace))
  add(path_564136, "resourceGroupName", newJString(resourceGroupName))
  add(path_564136, "adaptiveNetworkHardeningResourceName",
      newJString(adaptiveNetworkHardeningResourceName))
  if body != nil:
    body_564138 = body
  add(path_564136, "resourceName", newJString(resourceName))
  add(path_564136, "adaptiveNetworkHardeningEnforceAction",
      newJString(adaptiveNetworkHardeningEnforceAction))
  result = call_564135.call(path_564136, query_564137, nil, nil, body_564138)

var adaptiveNetworkHardeningsEnforce* = Call_AdaptiveNetworkHardeningsEnforce_564109(
    name: "adaptiveNetworkHardeningsEnforce", meth: HttpMethod.HttpPost,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/{resourceNamespace}/{resourceType}/{resourceName}/providers/Microsoft.Security/adaptiveNetworkHardenings/{adaptiveNetworkHardeningResourceName}/{adaptiveNetworkHardeningEnforceAction}",
    validator: validate_AdaptiveNetworkHardeningsEnforce_564110, base: "",
    url: url_AdaptiveNetworkHardeningsEnforce_564111, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
