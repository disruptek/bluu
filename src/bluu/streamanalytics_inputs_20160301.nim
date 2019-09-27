
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: StreamAnalyticsManagementClient
## version: 2016-03-01
## termsOfService: (not provided)
## license: (not provided)
## 
## 
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
  macServiceName = "streamanalytics-inputs"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_InputsListByStreamingJob_593646 = ref object of OpenApiRestCall_593424
proc url_InputsListByStreamingJob_593648(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StreamAnalytics/streamingjobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/inputs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InputsListByStreamingJob_593647(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all of the inputs under the specified streaming job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   subscriptionId: JString (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: JString (required)
  ##          : The name of the streaming job.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593822 = path.getOrDefault("resourceGroupName")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "resourceGroupName", valid_593822
  var valid_593823 = path.getOrDefault("subscriptionId")
  valid_593823 = validateParameter(valid_593823, JString, required = true,
                                 default = nil)
  if valid_593823 != nil:
    section.add "subscriptionId", valid_593823
  var valid_593824 = path.getOrDefault("jobName")
  valid_593824 = validateParameter(valid_593824, JString, required = true,
                                 default = nil)
  if valid_593824 != nil:
    section.add "jobName", valid_593824
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  ##   $select: JString
  ##          : The $select OData query parameter. This is a comma-separated list of structural properties to include in the response, or "*" to include all properties. By default, all properties are returned except diagnostics. Currently only accepts '*' as a valid value.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593825 = query.getOrDefault("api-version")
  valid_593825 = validateParameter(valid_593825, JString, required = true,
                                 default = nil)
  if valid_593825 != nil:
    section.add "api-version", valid_593825
  var valid_593826 = query.getOrDefault("$select")
  valid_593826 = validateParameter(valid_593826, JString, required = false,
                                 default = nil)
  if valid_593826 != nil:
    section.add "$select", valid_593826
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593849: Call_InputsListByStreamingJob_593646; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all of the inputs under the specified streaming job.
  ## 
  let valid = call_593849.validator(path, query, header, formData, body)
  let scheme = call_593849.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593849.url(scheme.get, call_593849.host, call_593849.base,
                         call_593849.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593849, url, valid)

proc call*(call_593920: Call_InputsListByStreamingJob_593646;
          resourceGroupName: string; apiVersion: string; subscriptionId: string;
          jobName: string; Select: string = ""): Recallable =
  ## inputsListByStreamingJob
  ## Lists all of the inputs under the specified streaming job.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   subscriptionId: string (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: string (required)
  ##          : The name of the streaming job.
  ##   Select: string
  ##         : The $select OData query parameter. This is a comma-separated list of structural properties to include in the response, or "*" to include all properties. By default, all properties are returned except diagnostics. Currently only accepts '*' as a valid value.
  var path_593921 = newJObject()
  var query_593923 = newJObject()
  add(path_593921, "resourceGroupName", newJString(resourceGroupName))
  add(query_593923, "api-version", newJString(apiVersion))
  add(path_593921, "subscriptionId", newJString(subscriptionId))
  add(path_593921, "jobName", newJString(jobName))
  add(query_593923, "$select", newJString(Select))
  result = call_593920.call(path_593921, query_593923, nil, nil, nil)

var inputsListByStreamingJob* = Call_InputsListByStreamingJob_593646(
    name: "inputsListByStreamingJob", meth: HttpMethod.HttpGet,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StreamAnalytics/streamingjobs/{jobName}/inputs",
    validator: validate_InputsListByStreamingJob_593647, base: "",
    url: url_InputsListByStreamingJob_593648, schemes: {Scheme.Https})
type
  Call_InputsCreateOrReplace_593974 = ref object of OpenApiRestCall_593424
proc url_InputsCreateOrReplace_593976(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  assert "inputName" in path, "`inputName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StreamAnalytics/streamingjobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/inputs/"),
               (kind: VariableSegment, value: "inputName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InputsCreateOrReplace_593975(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an input or replaces an already existing input under an existing streaming job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   inputName: JString (required)
  ##            : The name of the input.
  ##   subscriptionId: JString (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: JString (required)
  ##          : The name of the streaming job.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593994 = path.getOrDefault("resourceGroupName")
  valid_593994 = validateParameter(valid_593994, JString, required = true,
                                 default = nil)
  if valid_593994 != nil:
    section.add "resourceGroupName", valid_593994
  var valid_593995 = path.getOrDefault("inputName")
  valid_593995 = validateParameter(valid_593995, JString, required = true,
                                 default = nil)
  if valid_593995 != nil:
    section.add "inputName", valid_593995
  var valid_593996 = path.getOrDefault("subscriptionId")
  valid_593996 = validateParameter(valid_593996, JString, required = true,
                                 default = nil)
  if valid_593996 != nil:
    section.add "subscriptionId", valid_593996
  var valid_593997 = path.getOrDefault("jobName")
  valid_593997 = validateParameter(valid_593997, JString, required = true,
                                 default = nil)
  if valid_593997 != nil:
    section.add "jobName", valid_593997
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593998 = query.getOrDefault("api-version")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = nil)
  if valid_593998 != nil:
    section.add "api-version", valid_593998
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The ETag of the input. Omit this value to always overwrite the current input. Specify the last-seen ETag value to prevent accidentally overwriting concurrent changes.
  ##   If-None-Match: JString
  ##                : Set to '*' to allow a new input to be created, but to prevent updating an existing input. Other values will result in a 412 Pre-condition Failed response.
  section = newJObject()
  var valid_593999 = header.getOrDefault("If-Match")
  valid_593999 = validateParameter(valid_593999, JString, required = false,
                                 default = nil)
  if valid_593999 != nil:
    section.add "If-Match", valid_593999
  var valid_594000 = header.getOrDefault("If-None-Match")
  valid_594000 = validateParameter(valid_594000, JString, required = false,
                                 default = nil)
  if valid_594000 != nil:
    section.add "If-None-Match", valid_594000
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : The definition of the input that will be used to create a new input or replace the existing one under the streaming job.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594002: Call_InputsCreateOrReplace_593974; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an input or replaces an already existing input under an existing streaming job.
  ## 
  let valid = call_594002.validator(path, query, header, formData, body)
  let scheme = call_594002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594002.url(scheme.get, call_594002.host, call_594002.base,
                         call_594002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594002, url, valid)

proc call*(call_594003: Call_InputsCreateOrReplace_593974;
          resourceGroupName: string; apiVersion: string; inputName: string;
          subscriptionId: string; input: JsonNode; jobName: string): Recallable =
  ## inputsCreateOrReplace
  ## Creates an input or replaces an already existing input under an existing streaming job.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   inputName: string (required)
  ##            : The name of the input.
  ##   subscriptionId: string (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   input: JObject (required)
  ##        : The definition of the input that will be used to create a new input or replace the existing one under the streaming job.
  ##   jobName: string (required)
  ##          : The name of the streaming job.
  var path_594004 = newJObject()
  var query_594005 = newJObject()
  var body_594006 = newJObject()
  add(path_594004, "resourceGroupName", newJString(resourceGroupName))
  add(query_594005, "api-version", newJString(apiVersion))
  add(path_594004, "inputName", newJString(inputName))
  add(path_594004, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_594006 = input
  add(path_594004, "jobName", newJString(jobName))
  result = call_594003.call(path_594004, query_594005, nil, nil, body_594006)

var inputsCreateOrReplace* = Call_InputsCreateOrReplace_593974(
    name: "inputsCreateOrReplace", meth: HttpMethod.HttpPut,
    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StreamAnalytics/streamingjobs/{jobName}/inputs/{inputName}",
    validator: validate_InputsCreateOrReplace_593975, base: "",
    url: url_InputsCreateOrReplace_593976, schemes: {Scheme.Https})
type
  Call_InputsGet_593962 = ref object of OpenApiRestCall_593424
proc url_InputsGet_593964(protocol: Scheme; host: string; base: string; route: string;
                         path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  assert "inputName" in path, "`inputName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StreamAnalytics/streamingjobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/inputs/"),
               (kind: VariableSegment, value: "inputName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InputsGet_593963(path: JsonNode; query: JsonNode; header: JsonNode;
                              formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets details about the specified input.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   inputName: JString (required)
  ##            : The name of the input.
  ##   subscriptionId: JString (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: JString (required)
  ##          : The name of the streaming job.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_593965 = path.getOrDefault("resourceGroupName")
  valid_593965 = validateParameter(valid_593965, JString, required = true,
                                 default = nil)
  if valid_593965 != nil:
    section.add "resourceGroupName", valid_593965
  var valid_593966 = path.getOrDefault("inputName")
  valid_593966 = validateParameter(valid_593966, JString, required = true,
                                 default = nil)
  if valid_593966 != nil:
    section.add "inputName", valid_593966
  var valid_593967 = path.getOrDefault("subscriptionId")
  valid_593967 = validateParameter(valid_593967, JString, required = true,
                                 default = nil)
  if valid_593967 != nil:
    section.add "subscriptionId", valid_593967
  var valid_593968 = path.getOrDefault("jobName")
  valid_593968 = validateParameter(valid_593968, JString, required = true,
                                 default = nil)
  if valid_593968 != nil:
    section.add "jobName", valid_593968
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_593969 = query.getOrDefault("api-version")
  valid_593969 = validateParameter(valid_593969, JString, required = true,
                                 default = nil)
  if valid_593969 != nil:
    section.add "api-version", valid_593969
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593970: Call_InputsGet_593962; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets details about the specified input.
  ## 
  let valid = call_593970.validator(path, query, header, formData, body)
  let scheme = call_593970.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593970.url(scheme.get, call_593970.host, call_593970.base,
                         call_593970.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593970, url, valid)

proc call*(call_593971: Call_InputsGet_593962; resourceGroupName: string;
          apiVersion: string; inputName: string; subscriptionId: string;
          jobName: string): Recallable =
  ## inputsGet
  ## Gets details about the specified input.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   inputName: string (required)
  ##            : The name of the input.
  ##   subscriptionId: string (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: string (required)
  ##          : The name of the streaming job.
  var path_593972 = newJObject()
  var query_593973 = newJObject()
  add(path_593972, "resourceGroupName", newJString(resourceGroupName))
  add(query_593973, "api-version", newJString(apiVersion))
  add(path_593972, "inputName", newJString(inputName))
  add(path_593972, "subscriptionId", newJString(subscriptionId))
  add(path_593972, "jobName", newJString(jobName))
  result = call_593971.call(path_593972, query_593973, nil, nil, nil)

var inputsGet* = Call_InputsGet_593962(name: "inputsGet", meth: HttpMethod.HttpGet,
                                    host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StreamAnalytics/streamingjobs/{jobName}/inputs/{inputName}",
                                    validator: validate_InputsGet_593963,
                                    base: "", url: url_InputsGet_593964,
                                    schemes: {Scheme.Https})
type
  Call_InputsUpdate_594019 = ref object of OpenApiRestCall_593424
proc url_InputsUpdate_594021(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  assert "inputName" in path, "`inputName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StreamAnalytics/streamingjobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/inputs/"),
               (kind: VariableSegment, value: "inputName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InputsUpdate_594020(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing input under an existing streaming job. This can be used to partially update (ie. update one or two properties) an input without affecting the rest the job or input definition.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   inputName: JString (required)
  ##            : The name of the input.
  ##   subscriptionId: JString (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: JString (required)
  ##          : The name of the streaming job.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594022 = path.getOrDefault("resourceGroupName")
  valid_594022 = validateParameter(valid_594022, JString, required = true,
                                 default = nil)
  if valid_594022 != nil:
    section.add "resourceGroupName", valid_594022
  var valid_594023 = path.getOrDefault("inputName")
  valid_594023 = validateParameter(valid_594023, JString, required = true,
                                 default = nil)
  if valid_594023 != nil:
    section.add "inputName", valid_594023
  var valid_594024 = path.getOrDefault("subscriptionId")
  valid_594024 = validateParameter(valid_594024, JString, required = true,
                                 default = nil)
  if valid_594024 != nil:
    section.add "subscriptionId", valid_594024
  var valid_594025 = path.getOrDefault("jobName")
  valid_594025 = validateParameter(valid_594025, JString, required = true,
                                 default = nil)
  if valid_594025 != nil:
    section.add "jobName", valid_594025
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594026 = query.getOrDefault("api-version")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "api-version", valid_594026
  result.add "query", section
  ## parameters in `header` object:
  ##   If-Match: JString
  ##           : The ETag of the input. Omit this value to always overwrite the current input. Specify the last-seen ETag value to prevent accidentally overwriting concurrent changes.
  section = newJObject()
  var valid_594027 = header.getOrDefault("If-Match")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = nil)
  if valid_594027 != nil:
    section.add "If-Match", valid_594027
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject (required)
  ##        : An Input object. The properties specified here will overwrite the corresponding properties in the existing input (ie. Those properties will be updated). Any properties that are set to null here will mean that the corresponding property in the existing input will remain the same and not change as a result of this PATCH operation.
  assert body != nil, "body argument is necessary"
  section = validateParameter(body, JObject, required = true, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594029: Call_InputsUpdate_594019; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing input under an existing streaming job. This can be used to partially update (ie. update one or two properties) an input without affecting the rest the job or input definition.
  ## 
  let valid = call_594029.validator(path, query, header, formData, body)
  let scheme = call_594029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594029.url(scheme.get, call_594029.host, call_594029.base,
                         call_594029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594029, url, valid)

proc call*(call_594030: Call_InputsUpdate_594019; resourceGroupName: string;
          apiVersion: string; inputName: string; subscriptionId: string;
          input: JsonNode; jobName: string): Recallable =
  ## inputsUpdate
  ## Updates an existing input under an existing streaming job. This can be used to partially update (ie. update one or two properties) an input without affecting the rest the job or input definition.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   inputName: string (required)
  ##            : The name of the input.
  ##   subscriptionId: string (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   input: JObject (required)
  ##        : An Input object. The properties specified here will overwrite the corresponding properties in the existing input (ie. Those properties will be updated). Any properties that are set to null here will mean that the corresponding property in the existing input will remain the same and not change as a result of this PATCH operation.
  ##   jobName: string (required)
  ##          : The name of the streaming job.
  var path_594031 = newJObject()
  var query_594032 = newJObject()
  var body_594033 = newJObject()
  add(path_594031, "resourceGroupName", newJString(resourceGroupName))
  add(query_594032, "api-version", newJString(apiVersion))
  add(path_594031, "inputName", newJString(inputName))
  add(path_594031, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_594033 = input
  add(path_594031, "jobName", newJString(jobName))
  result = call_594030.call(path_594031, query_594032, nil, nil, body_594033)

var inputsUpdate* = Call_InputsUpdate_594019(name: "inputsUpdate",
    meth: HttpMethod.HttpPatch, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StreamAnalytics/streamingjobs/{jobName}/inputs/{inputName}",
    validator: validate_InputsUpdate_594020, base: "", url: url_InputsUpdate_594021,
    schemes: {Scheme.Https})
type
  Call_InputsDelete_594007 = ref object of OpenApiRestCall_593424
proc url_InputsDelete_594009(protocol: Scheme; host: string; base: string;
                            route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  assert "inputName" in path, "`inputName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StreamAnalytics/streamingjobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/inputs/"),
               (kind: VariableSegment, value: "inputName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InputsDelete_594008(path: JsonNode; query: JsonNode; header: JsonNode;
                                 formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an input from the streaming job.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   inputName: JString (required)
  ##            : The name of the input.
  ##   subscriptionId: JString (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: JString (required)
  ##          : The name of the streaming job.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594010 = path.getOrDefault("resourceGroupName")
  valid_594010 = validateParameter(valid_594010, JString, required = true,
                                 default = nil)
  if valid_594010 != nil:
    section.add "resourceGroupName", valid_594010
  var valid_594011 = path.getOrDefault("inputName")
  valid_594011 = validateParameter(valid_594011, JString, required = true,
                                 default = nil)
  if valid_594011 != nil:
    section.add "inputName", valid_594011
  var valid_594012 = path.getOrDefault("subscriptionId")
  valid_594012 = validateParameter(valid_594012, JString, required = true,
                                 default = nil)
  if valid_594012 != nil:
    section.add "subscriptionId", valid_594012
  var valid_594013 = path.getOrDefault("jobName")
  valid_594013 = validateParameter(valid_594013, JString, required = true,
                                 default = nil)
  if valid_594013 != nil:
    section.add "jobName", valid_594013
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594014 = query.getOrDefault("api-version")
  valid_594014 = validateParameter(valid_594014, JString, required = true,
                                 default = nil)
  if valid_594014 != nil:
    section.add "api-version", valid_594014
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594015: Call_InputsDelete_594007; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an input from the streaming job.
  ## 
  let valid = call_594015.validator(path, query, header, formData, body)
  let scheme = call_594015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594015.url(scheme.get, call_594015.host, call_594015.base,
                         call_594015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594015, url, valid)

proc call*(call_594016: Call_InputsDelete_594007; resourceGroupName: string;
          apiVersion: string; inputName: string; subscriptionId: string;
          jobName: string): Recallable =
  ## inputsDelete
  ## Deletes an input from the streaming job.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   inputName: string (required)
  ##            : The name of the input.
  ##   subscriptionId: string (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: string (required)
  ##          : The name of the streaming job.
  var path_594017 = newJObject()
  var query_594018 = newJObject()
  add(path_594017, "resourceGroupName", newJString(resourceGroupName))
  add(query_594018, "api-version", newJString(apiVersion))
  add(path_594017, "inputName", newJString(inputName))
  add(path_594017, "subscriptionId", newJString(subscriptionId))
  add(path_594017, "jobName", newJString(jobName))
  result = call_594016.call(path_594017, query_594018, nil, nil, nil)

var inputsDelete* = Call_InputsDelete_594007(name: "inputsDelete",
    meth: HttpMethod.HttpDelete, host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StreamAnalytics/streamingjobs/{jobName}/inputs/{inputName}",
    validator: validate_InputsDelete_594008, base: "", url: url_InputsDelete_594009,
    schemes: {Scheme.Https})
type
  Call_InputsTest_594034 = ref object of OpenApiRestCall_593424
proc url_InputsTest_594036(protocol: Scheme; host: string; base: string; route: string;
                          path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscriptionId" in path, "`subscriptionId` is a required path parameter"
  assert "resourceGroupName" in path,
        "`resourceGroupName` is a required path parameter"
  assert "jobName" in path, "`jobName` is a required path parameter"
  assert "inputName" in path, "`inputName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/subscriptions/"),
               (kind: VariableSegment, value: "subscriptionId"),
               (kind: ConstantSegment, value: "/resourcegroups/"),
               (kind: VariableSegment, value: "resourceGroupName"), (
        kind: ConstantSegment,
        value: "/providers/Microsoft.StreamAnalytics/streamingjobs/"),
               (kind: VariableSegment, value: "jobName"),
               (kind: ConstantSegment, value: "/inputs/"),
               (kind: VariableSegment, value: "inputName"),
               (kind: ConstantSegment, value: "/test")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_InputsTest_594035(path: JsonNode; query: JsonNode; header: JsonNode;
                               formData: JsonNode; body: JsonNode): JsonNode =
  ## Tests whether an input’s datasource is reachable and usable by the Azure Stream Analytics service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resourceGroupName: JString (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   inputName: JString (required)
  ##            : The name of the input.
  ##   subscriptionId: JString (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   jobName: JString (required)
  ##          : The name of the streaming job.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `resourceGroupName` field"
  var valid_594037 = path.getOrDefault("resourceGroupName")
  valid_594037 = validateParameter(valid_594037, JString, required = true,
                                 default = nil)
  if valid_594037 != nil:
    section.add "resourceGroupName", valid_594037
  var valid_594038 = path.getOrDefault("inputName")
  valid_594038 = validateParameter(valid_594038, JString, required = true,
                                 default = nil)
  if valid_594038 != nil:
    section.add "inputName", valid_594038
  var valid_594039 = path.getOrDefault("subscriptionId")
  valid_594039 = validateParameter(valid_594039, JString, required = true,
                                 default = nil)
  if valid_594039 != nil:
    section.add "subscriptionId", valid_594039
  var valid_594040 = path.getOrDefault("jobName")
  valid_594040 = validateParameter(valid_594040, JString, required = true,
                                 default = nil)
  if valid_594040 != nil:
    section.add "jobName", valid_594040
  result.add "path", section
  ## parameters in `query` object:
  ##   api-version: JString (required)
  ##              : Client Api Version.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `api-version` field"
  var valid_594041 = query.getOrDefault("api-version")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "api-version", valid_594041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   input: JObject
  ##        : If the input specified does not already exist, this parameter must contain the full input definition intended to be tested. If the input specified already exists, this parameter can be left null to test the existing input as is or if specified, the properties specified will overwrite the corresponding properties in the existing input (exactly like a PATCH operation) and the resulting input will be tested.
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594043: Call_InputsTest_594034; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Tests whether an input’s datasource is reachable and usable by the Azure Stream Analytics service.
  ## 
  let valid = call_594043.validator(path, query, header, formData, body)
  let scheme = call_594043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594043.url(scheme.get, call_594043.host, call_594043.base,
                         call_594043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594043, url, valid)

proc call*(call_594044: Call_InputsTest_594034; resourceGroupName: string;
          apiVersion: string; inputName: string; subscriptionId: string;
          jobName: string; input: JsonNode = nil): Recallable =
  ## inputsTest
  ## Tests whether an input’s datasource is reachable and usable by the Azure Stream Analytics service.
  ##   resourceGroupName: string (required)
  ##                    : The name of the resource group that contains the resource. You can obtain this value from the Azure Resource Manager API or the portal.
  ##   apiVersion: string (required)
  ##             : Client Api Version.
  ##   inputName: string (required)
  ##            : The name of the input.
  ##   subscriptionId: string (required)
  ##                 : GUID which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.
  ##   input: JObject
  ##        : If the input specified does not already exist, this parameter must contain the full input definition intended to be tested. If the input specified already exists, this parameter can be left null to test the existing input as is or if specified, the properties specified will overwrite the corresponding properties in the existing input (exactly like a PATCH operation) and the resulting input will be tested.
  ##   jobName: string (required)
  ##          : The name of the streaming job.
  var path_594045 = newJObject()
  var query_594046 = newJObject()
  var body_594047 = newJObject()
  add(path_594045, "resourceGroupName", newJString(resourceGroupName))
  add(query_594046, "api-version", newJString(apiVersion))
  add(path_594045, "inputName", newJString(inputName))
  add(path_594045, "subscriptionId", newJString(subscriptionId))
  if input != nil:
    body_594047 = input
  add(path_594045, "jobName", newJString(jobName))
  result = call_594044.call(path_594045, query_594046, nil, nil, body_594047)

var inputsTest* = Call_InputsTest_594034(name: "inputsTest",
                                      meth: HttpMethod.HttpPost,
                                      host: "management.azure.com", route: "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/Microsoft.StreamAnalytics/streamingjobs/{jobName}/inputs/{inputName}/test",
                                      validator: validate_InputsTest_594035,
                                      base: "", url: url_InputsTest_594036,
                                      schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
